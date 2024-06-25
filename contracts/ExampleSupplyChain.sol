// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ExampleSupplyChain is Ownable {
    //////////////////////////////////////////////////////////////////
    // Storage                                                      //
    //////////////////////////////////////////////////////////////////
    uint256 public _firstProcessLotId;
    uint256 public _secondProcessLotId;
    uint256 public _packingLotId;
    uint256 public _transportLotId;

    //////////////////////////////////////////////////////////////////
    // Events                                                      //
    //////////////////////////////////////////////////////////////////

    event CreateLotEvent(
        string lotType,
        string quantity,
        string operatorId,
        string originId,
        string lotNo,
        string transporterId
    );

    event FirstProcessEvent(
        string lotNos,
        string operatorId,
        string machineId,
        string processingHouseId,
        string timestamp,
        string firstProcessLotId
    );

    event SecondProcessEvent(
        string firstProcessLotIds,
        string machineId,
        string operatorId,
        string secondProcessOutputLotId,
        string secondProcessLotId
    );

    event PackagingEvent(
        string secondProcessLotId,
        string operatorId,
        string packageId,
        string weight,
        string packagingType,
        string packingLotId
    );

    event TransportEvent(
        string packageId,
        string operatorId,
        string transporterId,
        string cartonId,
        string transportLotId
    );

    //////////////////////////////////////////////////////////////////
    // Constructor                                                  //
    //////////////////////////////////////////////////////////////////
    constructor() Ownable(msg.sender) {
        // Ownable constructor is called with an initial owner
    }

    //////////////////////////////////////////////////////////////////
    // CORE FUNCTIONS                                               //
    //////////////////////////////////////////////////////////////////
    function createLot(
        string memory lotType,
        string memory quantity,
        string memory operatorId,
        string memory originId,
        string memory lotNo,
        string memory transporterId
    ) external {
        emit CreateLotEvent(
            lotType,
            quantity,
            operatorId,
            originId,
            lotNo,
            transporterId
        );
    }

    function registerFirstProcess(
        string memory lotNos,
        string memory operatorId,
        string memory machineId,
        string memory processingHouseId,
        string memory timestamp
    ) external {
        _firstProcessLotId += 1;

        emit FirstProcessEvent(
            lotNos,
            operatorId,
            machineId,
            processingHouseId,
            timestamp,
            Strings.toString(_firstProcessLotId)
        );
    }

    function registerSecondProcess(
        string memory firstProcessLotIds,
        string memory machineId,
        string memory operatorId,
        string memory secondProcessOutputLotId
    ) external {
        _secondProcessLotId += 1;

        emit SecondProcessEvent(
            firstProcessLotIds,
            machineId,
            operatorId,
            secondProcessOutputLotId,
            Strings.toString(_secondProcessLotId)
        );
    }

    function packing(
        string memory secondProcessLotId,
        string memory operatorId,
        string memory packageId,
        string memory weight,
        string memory packagingType
    ) external {
        _packingLotId += 1;

        emit PackagingEvent(
            secondProcessLotId,
            operatorId,
            packageId,
            weight,
            packagingType,
            Strings.toString(_packingLotId)
        );
    }

    function transport(
        string memory packageId,
        string memory operatorId,
        string memory transporterId,
        string memory cartonId
    ) external {
        _transportLotId += 1;

        emit TransportEvent(
            packageId,
            operatorId,
            transporterId,
            cartonId,
            Strings.toString(_transportLotId)
        );
    }
}
