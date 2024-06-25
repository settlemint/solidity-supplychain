// modules/ExampleSupplyChainModule.js

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const ExampleSupplyChainModule = buildModule("ExampleSupplyChainModule", (m) => {
  const exampleSupplyChain = m.contract("ExampleSupplyChain", []);

  return { exampleSupplyChain };
});

export default  ExampleSupplyChainModule;
