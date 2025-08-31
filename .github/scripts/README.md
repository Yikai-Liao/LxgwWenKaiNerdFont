# AUR Publish Scripts

这个目录包含了用于自动发布 AUR 包的脚本，将复杂的 shell 逻辑从 GitHub Actions workflow 中分离出来。

## 脚本说明

### resolve-tag.sh
- **功能**: 自动检测最新的 git tag 和对应的包版本号
- **输出**: `tag` 和 `pkgver` 到 GitHub Actions 输出
- **回退逻辑**: release 事件 → 最新 release → tags 列表

### download-assets.sh
- **功能**: 下载 release 资产文件和许可证文件
- **参数**: `tag` `asset_name` `repository`
- **输出**: 文件的 SHA256 校验和到 GitHub Actions 输出

### setup-ssh.sh
- **功能**: 配置 SSH 访问 AUR
- **环境变量**: `AUR_SSH_PRIVATE_KEY` (from secrets)

### generate-pkgbuild.sh
- **功能**: 为指定包生成 PKGBUILD 文件
- **参数**: `pkgname` `pkgver` `asset` `sha_asset` `sha_license` `tag` `is_mono`
- **特性**: 自动递增 pkgrel，支持普通和 mono 变体

### generate-srcinfo.sh
- **功能**: 使用 Docker 为两个包生成 .SRCINFO 文件
- **依赖**: Docker (Arch Linux base image)

### commit-and-push.sh
- **功能**: 提交更改并推送到 AUR 仓库
- **参数**: `pkgver` `tag`
- **特性**: 只在有变更时提交，包含有意义的提交信息

## 使用方式

这些脚本通过 GitHub Actions workflow (aur-publish.yml) 自动调用，无需手动执行。每当有新的 release 发布时，workflow 会：

1. 检测最新版本
2. 下载资产和许可证
3. 克隆 AUR 仓库
4. 为普通和 mono 变体生成 PKGBUILD
5. 生成 .SRCINFO 文件
6. 提交并推送到 AUR

## 权限要求

- `AUR_SSH_PRIVATE_KEY`: AUR 访问的 SSH 私钥 (GitHub Secret)
- `GITHUB_TOKEN`: GitHub API 访问令牌 (自动提供)
