import { FirstProcess, Lot, Packing, SecondProcess, Transport } from '../../generated/schema';

import {
    CreateLotEvent,
    FirstProcessEvent,
    PackagingEvent,
    SecondProcessEvent,
    TransportEvent,
  } from '../../generated/supplychain/ExampleSupplyChain';

export function handleCreateLot(event: CreateLotEvent): void {
  const evt = new Lot(event.params.lotNo);

  evt.lotType = event.params.lotType;
  evt.quantity = event.params.quantity;
  evt.operatorId = event.params.operatorId;
  evt.originId = event.params.originId;
  evt.lotNo = event.params.lotNo;
  evt.transporterId = event.params.transporterId;

  evt.save();
}

export function handleFirstProcess(event: FirstProcessEvent): void {
  const evt = new FirstProcess(event.params.firstProcessLotId);
  const processLotArray = event.params.lotNos.split(',');

  for (let i = 0; i < processLotArray.length; i++) {
    const lot = Lot.load(processLotArray[i]);
    if (lot !== null) {
      lot.lotToFirstProcessMap = event.params.firstProcessLotId;
      lot.save();
    }
  }

  evt.lotNos = event.params.lotNos;
  evt.firstProcessLotId = event.params.firstProcessLotId;
  evt.operatorId = event.params.operatorId;
  evt.machineId = event.params.machineId;
  evt.processingHouseId = event.params.processingHouseId;

  evt.save();
}

export function handleSecondProcess(event: SecondProcessEvent): void {
  const evt = new SecondProcess(event.params.secondProcessLotId);

  const secondProcessMapArray = event.params.firstProcessLotIds.split(',');
  for (let i = 0; i < secondProcessMapArray.length; i++) {
    const firstProcess = FirstProcess.load(secondProcessMapArray[i]);
    if (firstProcess !== null) {
      firstProcess.secondProcessMap = event.params.secondProcessLotId;
      firstProcess.save();
    }
  }

  evt.firstProcessLotIds = event.params.firstProcessLotIds;
  evt.machineId = event.params.machineId;
  evt.operatorId = event.params.operatorId;
  evt.secondProcessLotId = event.params.secondProcessLotId;

  evt.save();
}

export function handlePackaging(event: PackagingEvent): void {
  const pkgIdArray = event.params.packageId.split(',');
  const pktWeight = event.params.weight.split(',');
  const pktPackagingType = event.params.packagingType.split(',');

  for (let i = 0; i < pkgIdArray.length; i++) {
    const evt = new Packing(`${pkgIdArray[i]}`);

    evt.packingLotId = event.params.packingLotId;
    evt.secondProcessLotId = event.params.secondProcessLotId;
    evt.secondProcessToPackingMap = event.params.secondProcessLotId;
    evt.operatorId = event.params.operatorId;
    evt.packageId = pkgIdArray[i];
    evt.weight = pktWeight[i];
    evt.packagingType = pktPackagingType[i];

    evt.save();
  }
}

export function handleTransport(event: TransportEvent): void {
  const evt = new Transport(event.params.transportLotId);
  const pkgIdArray = event.params.packageId.split(',');

  for (let i = 0; i < pkgIdArray.length; i++) {
    const packing = Packing.load(pkgIdArray[i]);
    if (packing !== null) {
      packing.packingToTransportMap = event.params.transportLotId;
      packing.save();
    }
  }

  evt.transportLotId = event.params.transportLotId;
  evt.packageId = event.params.packageId;
  evt.operatorId = event.params.operatorId;
  evt.transporterId = event.params.transporterId;
  evt.cartonId = event.params.cartonId;

  evt.save();
}