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
        if docpath =~ expand(non_git_root)
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
    set noautochdir
    let cur=expand('%:p:h') 
    exec "cd " . expand("%:p:h")
    if s:check_non_git_roots(a:quiet)
        if !a:quiet
            echom "Was a non-git root"
        endif
        return
    endif
    let sysout=split(system('git rev-parse --show-toplevel'), '\n')
    if len(sysout) < 1
        return
    endif
    let root = sysout[0]
    if !v:shell_error
        execute 'lcd' . root
        if !a:quiet
            echom "Root: " . root
        endif
    else
        exec "cd " . l:cur
        if !a:quiet
            echom "Not in git repo or under a recognised 'non_git_root'"
        endif
    end
endfunction
command! -bang Root call s:root(<bang>1)
