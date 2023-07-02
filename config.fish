function do-update
    # Check if already inside a tmux session
    if test -n "$TMUX"
        echo "Updating system..."
        sudo apt update -y
        sudo apt dist-upgrade -y
        sudo apt autoremove -y
        sudo apt autoclean
        sudo apt clean
        sudo apt install -f -y
        echo "Host system update and maintenance complete."

        # Check if Docker is installed
        if command -v docker >/dev/null 2>&1
            if command -v docker-compose >/dev/null 2>&1
                echo "Updating Docker containers..."
                cd ~/docker
                docker compose pull
                docker compose down
                docker compose up -d
                echo "Docker container update complete."
            else
                echo "docker compose is not installed. Please install docker compose to update Docker containers."
            end
        else
            echo "Docker is not installed."
        end

        echo "Waiting for 30 seconds before exiting tmux..."
        sleep 30
    else
        # Start a new tmux session and run the function within it
        echo "Starting tmux session..."
        tmux new-session -d -s system-update 'do-update'
        tmux attach-session -t system-update
    end

    # Exit the tmux session after 30 seconds
    tmux kill-session -t system-update
end
