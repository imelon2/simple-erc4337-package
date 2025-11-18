import dotenv from "dotenv";
import path from 'path';
import { toSimpleSmartAccount } from "permissionless/accounts";
import {
  createPublicClient,
  createWalletClient,
  formatEther,
  http,
} from "viem";
import { createBundlerClient } from "viem/account-abstraction";
import { privateKeyToAccount } from "viem/accounts";
import { localhost } from "viem/chains";
import consola from 'consola';
dotenv.config({ path: path.join(__dirname, '.env') });

async function main() {
  /**
   * Set up: instantiate wallets connected to providers
   */
  if (!process.env.PRIVATE_KEY) throw new Error("PRIVATE_KEY is required");
  if (!process.env.BUNDLER_URL) throw new Error("BUNDLER_URL is required");
  const walletPrivateKey = process.env.PRIVATE_KEY as `0x${string}`;
  const bundlerUrl = process.env.BUNDLER_URL;

  const client = createPublicClient({
    chain: localhost,
    transport: http(),
  });

  const bundlerClient = createBundlerClient({
    client,
    transport: http(bundlerUrl),
  });

  const owner = privateKeyToAccount(walletPrivateKey);

  /**
   * Set up: instantiate AA SimpleSmartAccount connected to provider
   */
  const account = await toSimpleSmartAccount({
    client,
    owner: owner,
  });

  const aaBalance = await client.getBalance({ address: account.address });
  if (aaBalance == 0n) {
    console.log(`Your AA Wallet no blanace`);
    console.log(
      `AA Wallet        : ${account.address} | ${formatEther(aaBalance)} ETH`
    );

    const walletClient = createWalletClient({
      account: owner,
      chain: localhost,
      transport: http(),
    });

    const hash = await walletClient.sendTransaction({
      to: account.address,
      value: 10000000000000000000n, //10 eth
    });
    const receipt = await client.waitForTransactionReceipt({ hash });

    console.log(receipt.status);
  }

  /**
   * Set up tx: set transaction minimal-data
   */
  const to = "0x0000000000000000000000000000000000004337";
  const value = 1n; // 1wei

  console.log("send UserOp to Bundler.... ");
  const userOpHash = await bundlerClient.sendUserOperation({
    account,
    calls: [
      {
        to: to,
        value,
      },
    ],
  });

  console.log("wait tx......");
  console.log();
  await bundlerClient.waitForUserOperationReceipt({
    hash: userOpHash,
  });
  const userOp = await bundlerClient.getUserOperation({ hash: userOpHash });

  consola.success("See UserOperation Tx: ")
  consola.box(`https://choiethlabs.netlify.app/transaction/${userOp.transactionHash}`)
}

(async () => {
  await main();
  process.exit();
})();
