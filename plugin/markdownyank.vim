" Markdown Yank In visual Mode Select some Code and type \my
" It populates into the " register a message that can be pasted into
" vimwiki/mardown
" and
" a slightly altered version compatible with pasting into slack
"
" Requires your local repository directory paths to match or gitlab organisation paths. (Feel free to alter)
"let g:myank_git_provider_path = substitute(getcwd(),"/Users/YOUR_USER/Code/","","")
"let g:gitlab_prefix = 'https://gitlab.com/YOUR_PREFIX/'

function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! s:chomped_system( ... )
    return substitute(call('system', a:000), '\n\+$', '', '')
endfunction

function! s:git_remote(...)

    if exists('g:myank_git_provider_path') && exists('g:gitlab_prefix')
        return ''
    endif

    let remote =  s:chomped_system('git remote get-url origin')
    " if remote is a https url then return the https url
    if match(remote, 'https:\/\/')
        return remote

    "if remote is a ssh url then convert into https
    elseif match(remote, 'git@')
        let remote = substitute(remote, 'git@', 'https://', '')
        let remote = substitute(remote, '\.git', '', '')
        return remote
    endif
endfunction

command! GitRemote echo s:git_remote()

function s:get_file_and_line(remote, is_escaped = 1)
    "return current file and line number relative to pwd. adjust for gitlab
    " let escchar = a:is_escaped ? "\\" : '' -- Dont have slack atm so not sure if this is needed.
    let escchar = a:is_escaped ? "" : ''

    if a:remote == "github"
        return expand("%") . escchar . '#L' . line("'<") . "-L" . line("'>")
    else
        return expand("%") . escchar . '#L' . line("'<") . "-" . line("'>")
    endif
endfunction

"return current git COMMIT_HASH
function! s:git_commit_hash()
    return s:chomped_system("git symbolic-ref --short HEAD")
endfunction

"find the git archives blob url prefix
function s:git_blob_link(is_escaped = 1)
    let remote = s:git_remote()
    "if gitlab.com then return with "~/blob/COMMIT_HASH/path/to/file"
    if match(remote, 'gitlab.com') > -1
        return remote . "/~/blob/" . s:git_commit_hash() . "/" . s:get_file_and_line("gitlab", a:is_escaped)
    endif
    " if github.com then return with "/blob/COMMIT_HASH/path/to/file"
    if match(remote, 'github.com') > -1
        return remote . "/blob/" . s:git_commit_hash() . "/" . s:get_file_and_line("github", a:is_escaped)
    endif

endfunction

function! MarkdownCodeYank()

    let gllink = s:git_blob_link()
    let contents = "`" . expand("%") . ":" . line("'<") . " - " . line("'>") . "`\n\n". "[git web](" . gllink . ")\n\n" .  "```" . &ft . "\n". s:get_visual_selection() ."\n```"

    let @" = contents
    let gllink = s:git_blob_link(0)

    let contents = "`" . expand("%") . ":" . line("'<") . " - " . line("'>") . "`\n\n". "[git web](" . gllink . ")\n\n" .  "```" .  &ft . "\n". s:get_visual_selection() ."\n```"
    let @+ = contents
endfunction

" vnoremap \my :call MarkdownCodeYank()<cr>
