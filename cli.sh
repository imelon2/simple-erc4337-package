
func_paymaster()
{
    case "$1" in
        "deposit")
            cast send 0x064Fbec1c03eC4004E7f9ADc5FAe2e2fB1857064 \
            "deposit() returns (uint256)" \
            -r http://127.0.0.1:8545 \
            --value 1ether \
            --private-key 0xfefcc139ed357999ed60c6a013947328d52e7d9751e93fd0274a2bfae5cbcb12
            ;;
        "getDeposit")
            cast call 0x064Fbec1c03eC4004E7f9ADc5FAe2e2fB1857064 \
            "getDeposit() returns (uint256)" \
            -r http://127.0.0.1:8545
            ;;
        "help" | "h")
            func_help
            ;;
        *)
        func_help
        ;;                                                                                   
    esac
}

case "$1" in
    "paymaster" | "pm")
        func_paymaster $2
        ;;
    "help" | "h")
        func_help
        ;;
    *)
    func_help
    ;;                                                                                   
esac