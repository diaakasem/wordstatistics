#!/bin/bash - 
#===============================================================================
#
#          FILE: install.sh
# 
#         USAGE: ./install.sh 
# 
#   DESCRIPTION: Installs the requirements for this project
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Diaa Kasem
#  ORGANIZATION: 
#       CREATED: 08/26/13 16:22:33 EET
#      REVISION:  0.1
#===============================================================================

set -o nounset                              # Treat unset variables as an error

#!/bin/bash
export NLTK_DATA="`pwd`/data";
sudo pip install -r requirements.txt;
python -c 'import nltk; nltk.download()'
python -m nltk.downloader -d "$NLTK_DATA" all.


