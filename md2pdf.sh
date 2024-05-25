brew install pandoc
brew tap homebrew/cask
brew install --cask basictex
eval "$(/usr/libexec/path_helper)"

# update $PATH to include path
export PATH=$PATH:/usr/local/texlive/2022basic/bin/universal-darwin

# check if successfully added to $PATH
echo $PATH | grep -q "/usr/local/texlive/2022basic/bin/universal-darwin" && echo "found" || echo "not found"

sudo tlmgr update --self
sudo tlmgr install texliveonfly
sudo tlmgr install xelatex
sudo tlmgr install adjustbox
sudo tlmgr install tcolorbox
sudo tlmgr install collectbox
sudo tlmgr install ucs
sudo tlmgr install environ
sudo tlmgr install trimspaces
sudo tlmgr install titling
sudo tlmgr install enumitem
sudo tlmgr install rsfs
sudo tlmgr install geometry

# run
pandoc --read=markdown --write=latex --pdf-engine=xelatex \
  --variable geometry:margin=10mm \
  --variable documentclass:extarticle \
  --variable fontsize:11pt \
  --variable papersize:a4 \
  --output=report.pdf report.md
