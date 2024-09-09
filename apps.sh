jq -c '.[]' "/workspace/apps.json" | while IFS= read -r item;do
        url=$(echo "$item" | jq -r '.url')
        branch=$(echo "$item" | jq -r '.branch')
        app=$(echo "$url" | sed 's/.*\///;s/\..*//' | sed 's/-/_/g')
        if [ ! -d "/workspace/frappe-bench/apps/$app" ]; then
            printf "installing $url $branch\n\n";
            eval "bench get-app" $url --branch $(echo "$item" | jq -r '.branch');
        else    
            printf "$app is already installed.\n";
        fi
done