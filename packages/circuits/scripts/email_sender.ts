/**
 * 
 * This script is for generating input for the email sender circuit.
 * 
 */


import { program } from "commander";
import fs from "fs";
import { promisify } from "util";
import { genEmailSenderInput } from "../helpers/email_sender";

program
  .requiredOption(
    "--email-file <string>",
    "Path to an email file"
  )
  .requiredOption(
    "--relayer-rand <string>",
    "Relayer's randomness"
  )
  .requiredOption(
    "--input-file <string>",
    "Path of a json file to write the generated input"
  )
  .option("--silent", "No console logs");

program.parse();
const args = program.opts();

function log(...message: any) {
  if (!args.silent) {
    console.log(...message);
  }
}

async function generate() {
  if (!args.inputFile.endsWith(".json")) {
    throw new Error("--input-file path arg must end with .json");
  }

  log("Generating Inputs for:", args);

  const circuitInputs = await genEmailSenderInput(args.emailFile, args.relayerRand);
  log("\n\nGenerated Inputs:", circuitInputs, "\n\n");

  await promisify(fs.writeFile)(args.inputFile, JSON.stringify(circuitInputs, null, 2));

  log("Inputs written to", args.inputFile);
}

generate().catch((err) => {
  console.error("Error generating inputs", err);
  process.exit(1);
});