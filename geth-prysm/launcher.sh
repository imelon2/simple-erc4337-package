SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


case "$1" in
    "run")
        echo $SCRIPT_DIR
        ;;
    "new")
        echo RUN geth new account $SCRIPT_DIR/node/execution/data
        geth --datadir $SCRIPT_DIR/node/execution/data account new
        ;;
    "clean")
        echo "Clear go-ethereum & Beacon & validator DB -- 🗑️"
        rm -rf $SCRIPT_DIR/node/consensus/beacondata $SCRIPT_DIR/node/consensus/validatordata
        rm -rf $SCRIPT_DIR/node/execution/data/geth
        rm -rf $SCRIPT_DIR/node/execution/data/geth.ipc
        ;;
    "help" | "h")
        func_help
        ;;
    *)
    func_help
    ;;                                                                                   
esac