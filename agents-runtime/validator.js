#!/usr/bin/env node

// Compatibility entrypoint for the documented command:
// node agents-runtime/validator.js ...
// The canonical implementation remains scripts/validate-agents.mjs.

import('./scripts/validate-agents.mjs').catch((error) => {
  console.error(error);
  process.exit(1);
});
