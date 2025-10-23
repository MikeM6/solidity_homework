# solidity_homework
This repository is for learning solidity and uploading homework.

## Project Structure

This repo follows a structure similar to OpenZeppelin for clarity:

- `contracts/` — Solidity sources
  - `interfaces/` — Public interfaces (ABIs)
  - `utils/` — Reusable libraries and helpers
    - `strings/` — `StringUtils.sol`, `RomanNumerals.sol`
  - `token/` — Add `erc20/`, `erc721/` here if you implement tokens
  - `access/` — Access control helpers (add if needed)
  - `mocks/` — Example/demo contracts for testing
- `test/` — Place tests here (Hardhat/Foundry/etc.)
- `scripts/` — Utility scripts (deploy, verify)
- `deploy/` — Deployment configs or scripts
- `docs/` — Documentation and notes

Examples now live under `contracts/mocks/`:
- `contracts/mocks/Counter.sol` (uses `ICounter` + `utils/CounterLib.sol`)
- `contracts/mocks/StringReverser.sol` (uses `utils/strings/StringUtils.sol`)
- `contracts/mocks/RomanExample.sol` and `RomanSelfTest.sol` (use `utils/strings/RomanNumerals.sol`)

Tooling:
- `.solhint.json` — Linting config targeting Solidity `^0.8.20`.
