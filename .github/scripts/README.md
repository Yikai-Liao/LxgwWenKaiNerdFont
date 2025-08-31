# AUR Publish Scripts

这个目录包含了用于自动发布 AUR 包的脚本，配合 [KSXGitHub/github-actions-deploy-aur](https://github.com/KSXGitHub/github-actions-deploy-aur) Action 使用。

## 脚本说明

### resolve-tag.sh
- **功能**: 自动检测最新的 git tag 和对应的包版本号
- **输出**: `tag` 和 `pkgver` 到 GitHub Actions 输出
- **回退逻辑**: release 事件 → 最新 release → tags 列表

### download-assets.sh
- **功能**: 下载 release 资产文件和许可证文件
- **参数**: `tag` `asset_name` `repository`
- **输出**: 文件的 SHA256 校验和到 GitHub Actions 输出

### generate-pkgbuild.sh
- **功能**: 为指定包生成 PKGBUILD 文件
- **参数**: `pkgname` `pkgver` `asset` `sha_asset` `sha_license` `tag` `is_mono`
- **特性**: 支持普通和 mono 变体，自动创建包目录

## 工作流程

workflow 使用成熟的第三方 Action `KSXGitHub/github-actions-deploy-aur@v4.1.1` 来处理：
- SSH 配置
- AUR 仓库克隆
- `.SRCINFO` 文件生成
- Git 提交和推送
- 校验和更新 (`updpkgsums`)

## 使用方式

这些脚本通过 GitHub Actions workflow (aur-publish.yml) 自动调用。每当有新的 release 发布时，workflow 会：

1. 检测最新版本 (resolve-tag.sh)
2. 下载资产和许可证 (download-assets.sh)
3. 为普通和 mono 变体生成 PKGBUILD (generate-pkgbuild.sh)
4. 使用第三方 Action 发布到 AUR

## 权限要求

- `AUR_SSH_PRIVATE_KEY`: AUR 访问的 SSH 私钥 (GitHub Secret)
- `GITHUB_TOKEN`: GitHub API 访问令牌 (自动提供)

## 优势

- **可靠性**: 使用经过验证的第三方 Action，避免自己处理复杂的权限和 Docker 问题
- **简洁性**: 大幅减少自定义脚本代码
- **并行处理**: 普通和 mono 包可以并行发布
- **自动校验**: Action 自动处理 `updpkgsums` 和 `.SRCINFO` 生成
