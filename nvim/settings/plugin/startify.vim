 "let g:ascii= [
 "            \ '                                 ________  __ __        ',
 "            \ '            __                  /\_____  \/\ \\ \       ',
 "            \ '    __  __ /\_\    ___ ___      \/___//''/''\ \ \\ \    ',
 "            \ '   /\ \/\ \\/\ \ /'' __` __`\        /'' /''  \ \ \\ \_ ',
 "            \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \      /'' /''__  \ \__ ,__\',
 "            \ '    \ \___/  \ \_\ \_\ \_\ \_\    /\_/ /\_\  \/_/\_\_/  ',
 "            \ '     \/__/    \/_/\/_/\/_/\/_/    \//  \/_/     \/_/    ',
 "            \ ]

let g:ascii = [
            \'███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
            \'████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
            \'██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
            \'██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
            \'██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
            \'╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
            \ ]
let g:startify_custom_header =
          \ 'startify#center(g:ascii)'

let g:startify_lists = [
    \ { 'type': 'dir',       'header': startify#center(['MRU '.getcwd()]) },
    \ { 'type': 'sessions',  'header': startify#center(['Sessions']) },
    \ { 'type': 'files',     'header': startify#center(['MRU']) },
    \ { 'type': 'bookmarks', 'header': startify#center(['Bookmarks']) },
    \ { 'type': 'commands',  'header': startify#center(['Commands']) },
    \ ]
let g:startify_padding_left = 69 " Hard coded padding for lists
