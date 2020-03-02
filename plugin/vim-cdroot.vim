if exists("g:loaded_vim_cdroot")
    finish
endif
let g:loaded_vim_cdroot = 1

function! s:check_non_git_roots(quiet)
    if !exists("g:non_git_roots")
        return 0
    endif
    let docpath=expand("%:p")
    for non_git_root in g:non_git_roots
        if docpath =~ non_git_root
            exec "lcd " . expand(non_git_root)
            if !a:quiet
                echo "Root: " . expand(non_git_root)
            endif
            return 1
        endif
    endfor
    return 0
endfunction

function! s:root(quiet)
    let cur=expand('%:p:h') 
    exec "cd " . expand("%:p:h")
    if s:check_non_git_roots(a:quiet)
        echom "Was a non-git root"
        return
    endif
    let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
    if !v:shell_error
        execute 'lcd' . root
        if !a:quiet
            echom "Root: " . root
        endif
    else
        exec "cd " . l:cur
        echom "Not in git repo or under a recognised 'non_git_root'"
    end
endfunction
command! -bang Root call s:root(<bang>1)
