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

# pandoc \
#     --read=markdown --write=latex --output=test.pdf \
#     --pdf-engine=xelatex \
#     --variable geometry:margin=20mm \
#     --variable fontsize=6pt \
#     test.md

# alternatively use a template: https://github.com/Wandmalfarbe/pandoc-latex-template/
# sudo tlmgr install collection-fontsrecommended
# sudo tlmgr install adjustbox babel-german background bidi collectbox csquotes everypage filehook footmisc footnotebackref framed fvextra letltxmacro ly1 mdframed mweights needspace pagecolor sourcecodepro sourcesanspro titling ucharcat ulem unicode-math upquote xecjk xurl zref

# run
pandoc --read=markdown --write=latex --pdf-engine=xelatex --variable geometry:margin=10mm --variable documentclass:extarticle --variable fontsize:11pt --variable papersize:a4 --output=report.pdf report.md
