import consola from "consola";
import dotenv from "dotenv";
import path from "path";
import { toSimpleSmartAccount } from "permissionless/accounts";
import { createPublicClient, http } from "viem";
import {
  createBundlerClient,
  createPaymasterClient,
} from "viem/account-abstraction";
import { privateKeyToAccount } from "viem/accounts";
import { localhost } from "viem/chains";
dotenv.config({ path: path.join(__dirname, ".env") });

async function main() {
  /**
   * Set up: instantiate wallets connected to providers
   */
  if (!process.env.PRIVATE_KEY) throw new Error("PRIVATE_KEY is required");
  if (!process.env.BUNDLER_URL) throw new Error("BUNDLER_URL is required");
  if (!process.env.PAYMASTER_URL) throw new Error("PAYMASTER_URL is required");

  const walletPrivateKey = process.env.PRIVATE_KEY as `0x${string}`;
  const bundlerUrl = process.env.BUNDLER_URL;
  const paymasterUrl = process.env.PAYMASTER_URL;

  const client = createPublicClient({
    chain: localhost,
    transport: http(),
  });

  const paymasterClient = createPaymasterClient({
    transport: http(paymasterUrl),
  });

  const bundlerClient = createBundlerClient({
    client,
    paymaster: paymasterClient,
    transport: http(bundlerUrl),
  });

  /**
   * Set up: instantiate AA SimpleSmartAccount connected to provider
   */
  const owner = privateKeyToAccount(walletPrivateKey);
  const account = await toSimpleSmartAccount({
    client,
    owner: owner,
  });

  /**
   * Set up tx: set transaction minimal-data
   */
  const to = "0x0000000000000000000000000000000000004337";
  const value = 0n; // 1wei

  console.log("send UserOp to Bundler.... ");
  const userOpHash = await bundlerClient.sendUserOperation({
    account,
    paymasterContext: {
      "policy-id": "1234-5678-90",
    },
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
  consola.success("See UserOperation Tx: ");
  consola.box(
    `https://choiethlabs.netlify.app/transaction/${userOp.transactionHash}`
  );
}

(async () => {
  await main();
  process.exit();
})();
