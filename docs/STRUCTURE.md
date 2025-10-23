# Project Structure

This Solidity workspace is organized similar to OpenZeppelin’s layout for clarity and growth.

- `contracts/`
  - `interfaces/` — External/public interfaces (e.g. `ICounter.sol`).
  - `utils/` — Reusable libraries and helpers.
    - `strings/` — String-related utilities (e.g. `StringUtils.sol`, `RomanNumerals.sol`).
  - `token/` — Space for token implementations if added later.
    - `erc20/`, `erc721/` — Follow OZ structure if you implement tokens.
  - `access/` — Access control helpers (e.g., `Ownable`) if needed later.
  - `mocks/` — Example/demo contracts used for testing and experimentation.

Other top-level folders:

- `test/` — Unit tests (JS/TS/Foundry/Hardhat).
- `scripts/` — Deployment and maintenance scripts.
- `deploy/` — Deployment definitions per network or framework.
- `docs/` — Documentation and notes.

As your codebase grows, mirror the OpenZeppelin conventions by placing interfaces alongside their modules (e.g., `token/erc20/IERC20.sol`) and grouping shared utilities under `utils/`.
