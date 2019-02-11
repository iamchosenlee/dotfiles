let g:lsp_async_completion = 1

augroup my-lsp
  autocmd! *
  if executable('typescript-language-server')
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'typescript-language-server',
          \ 'cmd': { si -> [&shell, &shellcmdflag, 'typescript-language-server --stdio'] },
          \ 'root_uri': { si -> lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json')) },
          \ 'whitelist': ['javascript', 'typescript'],
          \ 'priority': 5,
          \})
    autocmd FileType javascript call s:configure_lsp()
    autocmd FileType typescript call s:configure_lsp()
  endif

  if executable('pyls')
     autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': { si -> ['pyls'] },
          \ 'whitelist': ['python'],
          \ 'workspace_config': {
          \   'pyls': {
          \     'plugins': {
          \       'jedi_definition': {
          \         'follow_imports': v:true,
          \         'follow_builtin_imports': v:true,
          \       },
          \     },
          \   },
          \ },
          \ 'priority': 5,
          \})
    autocmd FileType python call s:configure_lsp()
  endif

  if executable('gopls')
     autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'gopls',
          \ 'cmd': { si -> ['gopls', '-mode', 'stdio'] },
          \ 'whitelist': ['go'],
          \ 'priority': 5,
          \})
    autocmd FileType go call s:configure_lsp()
  elseif executable('bingo')
     autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'bingo',
          \ 'cmd': { si -> ['bingo', '-mode', 'stdio'] },
          \ 'whitelist': ['go'],
          \ 'priority': 5,
          \})
    autocmd FileType go call s:configure_lsp()
  endif
augroup END

function! s:configure_lsp() abort
  nmap <buffer> gd <Plug>(lsp-definition)
  nmap <buffer> gD <Plug>(lsp-type-definition)
  nmap <buffer> gs <Plug>(lsp-document-symbol)
  nmap <buffer> gS <Plug>(lsp-workspace-symbol)
  nmap <buffer> gQ <Plug>(lsp-document-format)
  vmap <buffer> gQ <Plug>(lsp-document-format)
  nmap <buffer> gr <Plug>(lsp-references)
  nmap <buffer> gR <Plug>(lsp-declaration)
  nmap <buffer> [p <Plug>(lsp-previous-error)
  nmap <buffer> ]p <Plug>(lsp-next-error)
  nmap <buffer> K  <Plug>(lsp-hover)
  nmap <buffer> <F1> <Plug>(lsp-implementation)
  nmap <buffer> <F2> <Plug>(lsp-rename)
  setlocal omnifunc=lsp#complete
endfunction
