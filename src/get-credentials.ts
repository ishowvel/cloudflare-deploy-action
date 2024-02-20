const ERROR_READING_FILE = "Error reading file:";
import { promises as fs } from "fs";

// @DEV: these credentials are all disposable and tightly scoped
// for the purposes of assisting pull request reviewers
// and posting continuous deployment links

export async function getAppId() {
  try {
    console.trace("looking in current directory...");
    printFileStructure("find .").catch(console.error);
    console.trace("looking up one directory...");
    printFileStructure("find ..").catch(console.error);
    const data = await fs.readFile("./auth/app-id", "utf8");
    return data.trim();
  } catch (err) {
    console.error(ERROR_READING_FILE, err);
    return null;
  }
}

export async function getInstallationId() {
  try {
    const data = await fs.readFile("./auth/installation-id", "utf8");
    return data.trim();
  } catch (err) {
    console.error(ERROR_READING_FILE, err);
    return null;
  }
}

export async function getPrivateKey() {
  try {
    const files = await fs.readdir("./auth");
    const pemFile = files.find((file) => file.endsWith(".pem"));
    const data = pemFile ? await fs.readFile(`../auth/${pemFile}`, "utf8") : null;
    return data.trim();
  } catch (err) {
    console.error(ERROR_READING_FILE, err);
    return null;
  }
}

import { exec } from "child_process";

export async function printFileStructure(command: string) {
  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(`exec error: ${error}`);
      return;
    }
    console.log(`File structure:\n${stdout}`);
    if (stderr) {
      console.error(`stderr: ${stderr}`);
    }
  });
}
