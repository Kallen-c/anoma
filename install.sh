#!/bin/bash




#!/bin/bash
# Default variables
function="install"

option_value(){ echo "$1" | sed -e 's%^--[^=]*=%%g; s%^-[^=]*=%%g'; }
while test $# -gt 0; do
	case "$1" in
	-h|--help)
	  echo -e "\033[35m"
    echo -e "https://t.me/ro_cryptoo"
    echo -e "https://t.me/whitelistx1000"

    echo -ne "\033[35m██████╗░░█████╗░  "
    echo -e "\033[34m░█████╗░██████╗░██╗░░░██╗██████╗░████████╗░█████╗░"

    echo -ne "\033[35m██╔══██╗██╔══██╗  "
    echo -e "\033[34m██╔══██╗██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔══██╗"

    echo -ne "\033[35m██████╔╝██║░░██║  "
    echo -e "\033[34m██║░░╚═╝██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░░██║"

    echo -ne "\033[35m██╔══██╗██║░░██║  "
    echo -e "\033[34m██║░░██╗██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░░██║"

    echo -ne "\033[35m██║░░██║╚█████╔╝  "
    echo -e "\033[34m╚█████╔╝██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚█████╔╝"

    echo -ne "\033[35m╚═╝░░╚═╝░╚════╝░  "
    echo -e "\033[34m░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚════╝░"

    echo -e "\033[35m"
    sleep 1

		echo
		echo -e "${C_LGn}Options${RES}:"
		echo -e "  -ai, --auto-install  node auto-installation"
		echo -e "  -u,  --update        update the node"
		echo
		echo -e "${C_LGn}Useful URLs${RES}:"
		echo
		return 0 2>/dev/null; exit 0
		;;
	-ai|--auto-install)
		function="auto_install"
		shift
		;;
	-u|--update)
		function="update"
		shift
		;;
	*|--)
		break
		;;
	esac
done

printf_n(){ printf "$1\n" "${@:2}"; }
install() {
	sudo apt update
	sudo apt upgrade -y
	sudo apt install wget jq git build-essential -y
	cd
	local anoma_version=`wget -qO- https://api.github.com/repos/anoma/anoma/releases/latest | jq -r ".tag_name"`
	wget -q "https://github.com/anoma/anoma/releases/download/${anoma_version}/anoma-${anoma_version}-Linux-x86_64.tar.gz"
	tar -xvf "anoma-${anoma_version}-Linux-x86_64.tar.gz"
	chmod +x "$HOME/anoma-${anoma_version}-Linux-x86_64/anoman" "$HOME/anoma-${anoma_version}-Linux-x86_64/anomac" "$HOME/anoma-${anoma_version}-Linux-x86_64/anomaw" "$HOME/anoma-${anoma_version}-Linux-x86_64/anoma"
	mv "$HOME/anoma-${anoma_version}-Linux-x86_64/anoman" /usr/bin/anoman
	mv "$HOME/anoma-${anoma_version}-Linux-x86_64/anomac" /usr/bin/anomac
	mv "$HOME/anoma-${anoma_version}-Linux-x86_64/anomaw" /usr/bin/anomaw
	mv "$HOME/anoma-${anoma_version}-Linux-x86_64/anoma" /usr/bin/anoma
	mv "$HOME/anoma-${anoma_version}-Linux-x86_64/wasm" $HOME/wasm
	rm -rf "$HOME/anoma-${anoma_version}-Linux-x86_64" "anoma-${anoma_version}-Linux-x86_64.tar.gz"
	sed -i -e "s%^moniker *=.*%moniker = \"$anoma_moniker\"%" "$HOME/.anoma/anoma-feigenbaum-0.ebb9e9f9013/tendermint/config/config.toml"
}
auto_install() {
	sudo apt update
	sudo apt upgrade -y
	sudo apt install wget jq git build-essential -y
	. <(wget -qO- https://raw.githubusercontent.com/Kallen-c/utils/main/installers/tendermint.sh)
	cd
	local anoma_version=`wget -qO- https://api.github.com/repos/anoma/anoma/releases/latest | jq -r ".tag_name"`
	wget -q "https://github.com/anoma/anoma/releases/download/${anoma_version}/anoma-${anoma_version}-Linux-x86_64.tar.gz"
	tar -xvf "anoma-${anoma_version}-Linux-x86_64.tar.gz"
	chmod +x "$HOME/anoma-${anoma_version}-Linux-x86_64/anoman" "$HOME/anoma-${anoma_version}-Linux-x86_64/anomac" "$HOME/anoma-${anoma_version}-Linux-x86_64/anomaw" "$HOME/anoma-${anoma_version}-Linux-x86_64/anoma"
	mv "$HOME/anoma-${anoma_version}-Linux-x86_64/anoman" /usr/bin/anoman
	mv "$HOME/anoma-${anoma_version}-Linux-x86_64/anomac" /usr/bin/anomac
	mv "$HOME/anoma-${anoma_version}-Linux-x86_64/anomaw" /usr/bin/anomaw
	mv "$HOME/anoma-${anoma_version}-Linux-x86_64/anoma" /usr/bin/anoma
	mv "$HOME/anoma-${anoma_version}-Linux-x86_64/wasm" $HOME/wasm
	rm -rf "$HOME/anoma-${anoma_version}-Linux-x86_64" "anoma-${anoma_version}-Linux-x86_64.tar.gz"
	sed -i -e "s%^moniker *=.*%moniker = \"$anoma_moniker\"%" "$HOME/.anoma/anoma-feigenbaum-0.ebb9e9f9013/tendermint/config/config.toml"
	anoma client utils join-network --chain-id=anoma-feigenbaum-0.ebb9e9f9013
	printf "[Unit]
Description=Anoma Daemon
After=network-online.target

[Service]
User=$USER
Environment=RUST_BACKTRACE=full
ExecStart=`which anoma` --wasm-dir $HOME/wasm/ --base-dir $HOME/.anoma/ ledger
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/anomad.service
	sudo systemctl daemon-reload
	sudo systemctl enable anomad
	sudo systemctl restart anomad
	. <(wget -qO- https://raw.githubusercontent.com/Kallen-c/utils/main/miscellaneous/insert_variable.sh) -n anoma_log -v "sudo journalctl -f -n 100 -u anomad" -a
	. <(wget -qO- https://raw.githubusercontent.com/Kallen-c/utils/main/miscellaneous/insert_variable.sh) -n anoma_node_info -v ". <(wget -qO- https://raw.githubusercontent.com/Kallen-c/anoma/main/node_i.sh) -l RU 2> /dev/null" -a
}
update() {
	printf_n "${C_LGn}Coming soon${RES}"
}

# Actions
sudo apt install wget -y &>/dev/null
	  echo -e "\033[35m"
    echo -e "https://t.me/ro_cryptoo"
    echo -e "https://t.me/whitelistx1000"

    echo -ne "\033[35m██████╗░░█████╗░  "
    echo -e "\033[34m░█████╗░██████╗░██╗░░░██╗██████╗░████████╗░█████╗░"

    echo -ne "\033[35m██╔══██╗██╔══██╗  "
    echo -e "\033[34m██╔══██╗██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔══██╗"

    echo -ne "\033[35m██████╔╝██║░░██║  "
    echo -e "\033[34m██║░░╚═╝██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░░██║"

    echo -ne "\033[35m██╔══██╗██║░░██║  "
    echo -e "\033[34m██║░░██╗██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░░██║"

    echo -ne "\033[35m██║░░██║╚█████╔╝  "
    echo -e "\033[34m╚█████╔╝██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚█████╔╝"

    echo -ne "\033[35m╚═╝░░╚═╝░╚════╝░  "
    echo -e "\033[34m░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚════╝░"

    echo -e "\033[35m"
    sleep 1
$function
printf_n "${C_LGn}Done!${RES}"
