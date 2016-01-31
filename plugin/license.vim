" Copyright 2016 David Stanek <dstanek@dstanek.com>"
"
" Licensed under the Apache License, Version 2.0 (the "License"); you may
" not use this file except in compliance with the License. You may obtain
" a copy of the License at
"
"     http://www.apache.org/licenses/LICENSE-2.0
"
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
" WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
" License for the specific language governing permissions and limitations
" under the License."

if exists('g:loaded_vim_license') || &cp
    finish
endif
let g:loaded_vim_license = 1

if !exists('g:license')
    let g:license = 'apache2'
endif

if !exists('g:license_copyright_owner')
    let g:license_copyright_owner = 'Anonymous'
endif

let s:plugin_path = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let s:licenses_path = printf('%s/licenses', s:plugin_path)

function! s:get_comment_string()  " {{{
    let comment_string = &commentstring
    if match(comment_string, ' %s') == -1
        " make sure there is a space because I like things pretty!
        let comment_string = substitute(comment_string, '%s', ' %s', '')
    endif
    return comment_string
endfunction  " }}}

function! s:get_license_text(filename, comment_string)  " {{{
    let lines = readfile(a:filename)
    let lines[0] = substitute(lines[0], '<copyright-year>', strftime('%Y'), '')
    let lines[0] = substitute(lines[0], '<copyright-owner>', g:license_copyright_owner, '')
    return map(lines, "substitute(printf(a:comment_string, v:val), ' *$', '', '')")
endfunction  " }}}

function! s:add_license()  " {{{
    let comment_string = s:get_comment_string()
    let license_text = s:get_license_text(
        \ printf('%s/%s.txt', s:licenses_path, g:license),
        \ comment_string)

    let cur_line = getpos('.')[1] - 1
    silent execute printf(':%dput =license_text', cur_line)
    call append('.', '')
endfunction  " }}}

function! s:fold_license()  " {{{
    " FIXME: Due to the way this looks for the start position of the license
    " text, this likely only works with the Apache license. The exception is
    " if you are using a copyright statement.

    " trying to mess with folds will fail if this is a diff view
    if &foldmethod == 'diff' | return | endif

    let s:cursor_pos = getpos('.')
    call cursor(1, 1)

    let comment_string = s:get_comment_string()

    let s:start_pos = search('^'.printf(comment_string, 'Copyright'), 'c')
    if s:start_pos == 0
        let s:start_pos = search('^'.printf(comment_string, 'Licensed'))
    endif
    if s:start_pos == 0 | return | endif

    let s:end_pos = search('\(^[^#]\|^$\)') - 1

    exec s:start_pos.','.s:end_pos.'fold'

    call setpos('.', s:cursor_pos)
endfunction  " }}}

command! -nargs=0 AddLicense :call <SID>add_license()
command! -nargs=0 FoldLicense :call <SID>fold_license()
nnoremap <silent> <Plug>AddLicense :AddLicense<CR>

" vim:foldenable:fdm=marker
