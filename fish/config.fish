if status is-interactive
    # Commands to run in interactive sessions can go here
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/yasith/miniconda3/bin/conda
    eval /Users/yasith/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/Users/yasith/miniconda3/etc/fish/conf.d/conda.fish"
        . "/Users/yasith/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/Users/yasith/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

# Initialize starship.rs
starship init fish | source

# The next line updates PATH for the Google Cloud SDK.
if test -f '/Users/yasith/Downloads/google-cloud-sdk/path.fish.inc'
    source '/Users/yasith/Downloads/google-cloud-sdk/path.fish.inc'
end

# The next line enables shell command completion for gcloud.
if test -f '/Users/yasith/Downloads/google-cloud-sdk/completion.fish.inc'
    source '/Users/yasith/Downloads/google-cloud-sdk/completion.fish.inc'
end

# Vim is NVim
alias vim="nvim"

# Open a tmux session for the current directory
function tmux-attach-current-dir
    # 1. Get the current directory name to use as the session name
    set -l session_name (basename $PWD | string replace -a '.' '_')

    # 2. Check if the session already exists
    if not tmux has-session -t=$session_name 2>/dev/null
        # Create it detached (-d) first, so we don't get forced into it yet
        # tmux new-session -d -s $session_name
        tmuxinator start project workspace=./ -n $session_name --no-attach
    end

    # 3. Smart Switch
    if test -n "$TMUX"
        # If we are ALREADY inside Tmux, switch the client to the new session
        tmux switch-client -t $session_name
    else
        # If we are OUTSIDE Tmux, attach to it
        tmux attach -t $session_name
    end
end

alias ta="tmux-attach-current-dir"

function tmux-attach-git-worktree
    if test (count $argv) -lt 1
        echo "Usage: tmux-attach-git-worktree <branch-or-worktree-name>"
        return 1
    end

    # --- 1. Path & Name Logic ---
    # If we are in a worktree already, we need to find the "real" root name
    # But assuming standard usage from main repo:
    set -l project_name (basename $PWD | string replace -a '.' '_')
    set -l wt_name $argv[1]
    
    # Sibling directory structure: ../project_worktrees/branch
    set -l wt_parent_dir "../"$project_name"_work_trees"
    set -l target_dir "$wt_parent_dir/$wt_name"
    
    # The session name combines project and branch (e.g., quantuma-fix-auth)
    set -l session_name "$project_name-$wt_name"

    # --- 2. Create Worktree ---
    if not test -d $wt_parent_dir
        mkdir -p $wt_parent_dir
    end

    if not test -d $target_dir
        # Try to create worktree. 2>/dev/null hides error if branch exists but checked out
        if git worktree add $target_dir $wt_name 2>/dev/null
            echo "✅ Created worktree at $target_dir"
        else
            # If standard add fails, try adding pointing to existing local branch
            git worktree add $target_dir
        end
    end

    # --- 3. Tmux Session Logic ---
    # Check if session exists
    if not tmux has-session -t=$session_name 2>/dev/null
        # Create new session starting in the worktree dir (-c)
        # tmux new-session -d -s $session_name -c $target_dir
        tmuxinator start project workspace=$target_dir -n $session_name
    end

    # --- 4. Smart Switch ---
    if test -n "$TMUX"
        # Switch current view to the new session
        tmux switch-client -t $session_name
    else
        # Attach if outside
        tmux attach -t $session_name
    end
end

alias tt="tmux-attach-git-worktree"

function tmux-remove-git-worktree
    # Safety: Ensure we are in a worktree path (simple check)
    if not string match -q "*_work_trees*" $PWD
        echo "⚠️  You don't seem to be in a worktree directory."
        return 1
    end

    set -l current_session (tmux display-message -p "#S")
    set -l current_path $PWD
    
    # 1. Switch back to the last session (usually Main)
    # We use 'switch-client -l' (last) or default to detached if only 1 session exists
    if tmux list-sessions | count > 1
        tmux switch-client -l
    else
        tmux detach
    end

    # 2. Kill the worktree session
    tmux kill-session -t $current_session

    # 3. Git Prune & Remove Folder
    # We move to the parent to safely delete
    cd ..
    
    # Git worktree remove usually handles the folder deletion, but we force cleanup
    # Extract the branch name from the path if needed, or just force remove path
    rm -rf $current_path
    git worktree prune
    
    echo "🗑️  Removed worktree and session: $current_session"
end

alias ttrm="tmux-remove-git-worktree"
