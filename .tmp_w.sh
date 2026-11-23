cd /e/NEW/Kniephos
echo '=== 撤回他的 workflow 改动（恢复为 main 版本）==='
git checkout main -- .github/workflows/build.yml .github/workflows/build-android.yml
git add -A
echo '=== 合并后的改动统计（相对 main）==='
git diff --cached --stat main | tail -5
echo '=== workflow 是否还有改动 ==='
git diff --cached --name-only main -- .github/workflows/ | head -3 || true
[ -z "$(git diff --cached --name-only main -- .github/workflows/)" ] && echo '  已撤回（workflow 无改动）' || echo '  仍有改动'
echo '=== 冲突标记复查 ==='
grep -rln '^<<<<<<<\|^>>>>>>>' lib/ android/ test/ docs/ 2>/dev/null | head -3 || echo '  无'