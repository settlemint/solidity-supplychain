// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../contracts/ExampleSupplyChain.sol";

contract ExampleSupplyChainTest is Test {
    ExampleSupplyChain supplyChain;

    function setUp() public {
        supplyChain = new ExampleSupplyChain();
    }

    function testCreateLotEmitsEvent() public {
        string memory lotType = "Type1";
        string memory quantity = "100";
        string memory operatorId = "OperatorID1";
        string memory originId = "Origin1";
        string memory lotNo = "LotNo1";
        string memory transporterId = "Transporter1";

        // We expect the CreateLotEvent to be emitted with specific parameters
        vm.expectEmit(true, true, true, true);

        // Emit the expected event
        emit ExampleSupplyChain.CreateLotEvent(lotType, quantity, operatorId, originId, lotNo, transporterId);

        supplyChain.createLot(lotType, quantity, operatorId, originId, lotNo, transporterId);
    }

    function testRegisterFirstProcessEmitsEvent() public {
        // Declare variables for the expected event parameters
        string memory lotNos = "LotNos123";
        string memory operatorId = "Operator456";
        string memory machineId = "Machine789";
        string memory processingHouseId = "ProcessingHouseXYZ";
        string memory timestamp = "123456789";

        // We expect the FirstProcessEvent to be emitted with specific parameters
        vm.expectEmit(true, true, true, true);

        // Emit the expected event from the contract instance
        emit ExampleSupplyChain.FirstProcessEvent(
            lotNos,
            operatorId,
            machineId,
            processingHouseId,
            timestamp,
            "1" // Assuming firstProcessLotId is "1" in this case
        );

        // Call the function that should emit the event
        supplyChain.registerFirstProcess(lotNos, operatorId, machineId, processingHouseId, timestamp);
    }

    function testRegisterSecondProcessEmitsEvent() public {
        // Declare variables for the expected event parameters
        string memory firstProcessLotIds = "1";
        string memory machineId = "Machine123";
        string memory operatorId = "Operator456";
        string memory secondProcessOutputLotId = "OutputLot789";

        // We expect the SecondProcessEvent to be emitted with specific parameters
        vm.expectEmit(true, true, true, true);

        // Emit the expected event from the contract instance
        emit ExampleSupplyChain.SecondProcessEvent(
            firstProcessLotIds,
            machineId,
            operatorId,
            secondProcessOutputLotId,
            "1" // Assuming secondProcessLotId is "1" in this case
        );

        // Call the function that should emit the event
        supplyChain.registerSecondProcess(firstProcessLotIds, machineId, operatorId, secondProcessOutputLotId);
    }

    function testPackingEmitsEvent() public {
        // Declare variables for the expected event parameters
        string memory secondProcessLotId = "1";
        string memory operatorId = "Operator123";
        string memory packageId = "Package456";
        string memory weight = "50";
        string memory packagingType = "Box";

        // We expect the PackagingEvent to be emitted with specific parameters
        vm.expectEmit(true, true, true, true);

        // Emit the expected event from the contract instance
        emit ExampleSupplyChain.PackagingEvent(
            secondProcessLotId,
            operatorId,
            packageId,
            weight,
            packagingType,
            "1" // Assuming packingLotId is "1" in this case
        );

        // Call the function that should emit the event
        supplyChain.packing(secondProcessLotId, operatorId, packageId, weight, packagingType);
    }

    function testTransportEmitsEvent() public {
        // Declare variables for the expected event parameters
        string memory packageId = "Package1";
        string memory operatorId = "Operator123";
        string memory transporterId = "TransporterABC";
        string memory cartonId = "Carton456";

        // We expect the TransportEvent to be emitted with specific parameters
        vm.expectEmit(true, true, true, true);

        // Emit the expected event from the contract instance
        emit ExampleSupplyChain.TransportEvent(
            packageId,
            operatorId,
            transporterId,
            cartonId,
            "1" // Assuming transportLotId is "1" in this case
        );

        // Call the function that should emit the event
        supplyChain.transport(packageId, operatorId, transporterId, cartonId);
    }
}
