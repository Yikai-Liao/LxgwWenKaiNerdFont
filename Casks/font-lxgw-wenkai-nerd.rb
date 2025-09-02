cask "font-lxgw-wenkai-nerd" do
  version "1.520"
  sha256 "bc779c8dc41db7c042ca38c45a6ed79a1591bf89cb8204fc11587bd1fd37aa24"

  url "https://github.com/Yikai-Liao/LxgwWenKaiNerdFont/releases/download/v#{version}/lxgw-wenkai-nerd.zip"
  name "LXGWWenKai Nerd Font"
  desc "LXGW WenKai font patched with Nerd Font glyphs (proportional variant)"
  homepage "https://github.com/Yikai-Liao/LxgwWenKaiNerdFont"

  font "LXGWWenKaiNerdFont-Light.ttf"
  font "LXGWWenKaiNerdFont-Regular.ttf"
  font "LXGWWenKaiNerdFont-Medium.ttf"

  # No zap stanza required

  caveats <<~EOS
    You have installed the proportional variant of LXGWWenKai Nerd Font.
    For the monospace variant, install font-lxgw-wenkai-mono-nerd.
  EOS
end