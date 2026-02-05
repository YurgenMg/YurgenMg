#!/bin/bash

# Script de Validación Automática para Portfolio YurgenMg
# Este script verifica que todos los cambios se hayan aplicado correctamente

echo "════════════════════════════════════════════════════════════════"
echo "   🔍 VALIDACIÓN AUTOMÁTICA DEL PORTFOLIO - YurgenMg"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Contadores
passed=0
failed=0

# Función para verificar
check() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ PASS${NC}: $2"
        ((passed++))
    else
        echo -e "${RED}❌ FAIL${NC}: $2"
        ((failed++))
    fi
}

echo "1. Verificando archivos del repositorio..."
echo "───────────────────────────────────────────────────────────────"

# Verificar que README.md existe
[ -f "README.md" ]
check $? "README.md existe"

# Verificar que LICENSE existe
[ -f "LICENSE" ]
check $? "LICENSE existe"

# Verificar que .gitignore existe
[ -f ".gitignore" ]
check $? ".gitignore existe"

echo ""
echo "2. Verificando contenido de README.md..."
echo "───────────────────────────────────────────────────────────────"

# Verificar que NO hay placeholders
! grep -q '\$XXX' README.md
check $? "No hay placeholders \$XXX"

! grep -q '\[TU_USERNAME\]' README.md
check $? "No hay placeholder [TU_USERNAME]"

# Verificar que LinkedIn URL está corregida
grep -q 'https://www.linkedin.com/in/yurgenmg/' README.md
check $? "LinkedIn URL correcta (sin duplicación)"

# Verificar que NO hay URL duplicada
! grep -q 'linkedin.com/in/https://' README.md
check $? "No hay URL de LinkedIn duplicada"

# Verificar proyectos conectados
grep -q 'Torre_Control' README.md
check $? "Proyecto Torre_Control conectado"

grep -q 'Dashboard_de_Analisis_de_Vehiculos_USA' README.md
check $? "Proyecto Dashboard_de_Analisis_de_Vehiculos_USA conectado"

# Verificar que proyectos antiguos fueron removidos
! grep -q 'logistica-data-analysis' README.md
check $? "Proyecto antiguo 'logistica-data-analysis' removido"

! grep -q 'python-automation-reports' README.md
check $? "Proyecto antiguo 'python-automation-reports' removido"

echo ""
echo "3. Verificando contenido de LICENSE..."
echo "───────────────────────────────────────────────────────────────"

grep -q 'MIT License' LICENSE
check $? "LICENSE contiene MIT License"

grep -q '2026' LICENSE
check $? "LICENSE tiene año 2026"

echo ""
echo "4. Verificando contenido de .gitignore..."
echo "───────────────────────────────────────────────────────────────"

grep -q '__pycache__' .gitignore
check $? ".gitignore incluye __pycache__"

grep -q '*.env' .gitignore
check $? ".gitignore protege archivos .env"

grep -q '.ipynb_checkpoints' .gitignore
check $? ".gitignore incluye notebooks checkpoints"

echo ""
echo "5. Verificando métricas del README..."
echo "───────────────────────────────────────────────────────────────"

# Contar proyectos destacados (debería ser 2)
project_count=$(grep -o 'github-readme-stats.vercel.app/api/pin' README.md | wc -l)
if [ "$project_count" -eq 2 ]; then
    echo -e "${GREEN}✅ PASS${NC}: Exactamente 2 proyectos destacados (correcto)"
    ((passed++))
else
    echo -e "${RED}❌ FAIL${NC}: Encontrados $project_count proyectos (esperados: 2)"
    ((failed++))
fi

# Verificar que hay métricas cuantificables
grep -q '35%' README.md
check $? "Métrica de 35% eficiencia presente"

grep -q '85%' README.md
check $? "Métrica de 85% precisión presente"

grep -q '40 horas/mes' README.md
check $? "Métrica de 40 horas/mes presente"

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "   📊 RESUMEN DE VALIDACIÓN"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo -e "Tests pasados: ${GREEN}$passed${NC}"
echo -e "Tests fallidos: ${RED}$failed${NC}"
echo ""

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}🎉 ¡EXCELENTE! Todas las validaciones pasaron.${NC}"
    echo "Tu portfolio está listo para ser mergeado."
    exit 0
else
    echo -e "${RED}⚠️  Algunos tests fallaron. Revisa los errores arriba.${NC}"
    exit 1
fi
