brew install --verbose --debug mactex
brew install pandoc

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
