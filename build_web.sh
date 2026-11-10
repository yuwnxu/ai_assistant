#!/usr/bin/env bash
# Собирает сайт для GitHub Pages и кладёт готовые файлы в корень репозитория.
# Использование:  ./build_web.sh [адрес_сервера]
#   ./build_web.sh https://ai-assistant-api.onrender.com
# Без аргумента адрес сервера в config.json остаётся прежним.
set -euo pipefail
cd "$(dirname "$0")"

API_URL="${1:-}"

flutter build web --release --no-web-resources-cdn --base-href /ai_assistant/

# адрес сервера хранится в config.json — берём новый или сохраняем текущий
if [ -n "$API_URL" ]; then
  printf '{\n  "apiUrl": "%s"\n}\n' "$API_URL" > build/web/config.json
elif [ -f config.json ]; then
  cp config.json build/web/config.json
fi

# копируем сборку в корень (рядом с исходниками assets/icons и т.д.)
cp -R build/web/. .
rm -f .last_build_id
echo "Готово. Закоммитьте и отправьте изменения: git add -A && git commit -m 'Обновление сайта' && git push"
