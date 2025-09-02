cask "font-lxgw-wenkai-mono-nerd" do
  version "1.520"
  sha256 "bc779c8dc41db7c042ca38c45a6ed79a1591bf89cb8204fc11587bd1fd37aa24"

  url "https://github.com/Yikai-Liao/LxgwWenKaiNerdFont/releases/download/v#{version}/lxgw-wenkai-nerd.zip"
  name "LXGWWenKaiMono Nerd Font"
  desc "LXGW WenKai font patched with Nerd Font glyphs (monospace variant)"
  homepage "https://github.com/Yikai-Liao/LxgwWenKaiNerdFont"

  font "LXGWWenKaiMonoNerdFont-Light.ttf"
  font "LXGWWenKaiMonoNerdFont-Regular.ttf"
  font "LXGWWenKaiMonoNerdFont-Medium.ttf"

  # No zap stanza required

  caveats <<~EOS
    You have installed the monospace variant of LXGWWenKai Nerd Font.
    For the proportional variant, install font-lxgw-wenkai-nerd.
  EOS
end