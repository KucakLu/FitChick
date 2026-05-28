# iPhone 17 Performance Repro Loop

Use this when testing freezes, hangs, and input delay on a physical iPhone.

## Instruments Setup

1. Open Product > Profile in Xcode with the physical iPhone selected.
2. Run these templates separately:
   - Hangs
   - Time Profiler
   - Memory Graph
   - Points of Interest
3. In Points of Interest, filter subsystem/category for `Performance`.

## Loop A: Dashboard Navigation

Repeat 5 times:

1. Start on Dashboard.
2. Tap gacha box.
3. Draw 1x.
4. Wait until `Tap anywhere to collect` appears.
5. Tap to open reward.
6. Tap collect to return to Dashboard.

Expected signposts:

- `RouteDashboardToGacha`
- `GachaExecuteSingle`
- `GachaOpeningAnimation`
- `RouteGachaToReward`
- `RouteRewardToDashboard`
- `DashboardAppear`
- `DashboardFetchTodayProgress`

## Loop B: Dress Up

Repeat 5 times:

1. Start on Dashboard.
2. Tap closet.
3. Select one item.
4. Tap Save.
5. Return to Dashboard.
6. Repeat with Dismiss after selecting a different item.

Expected signposts:

- `RouteDashboardToDressUp`
- `DressUpInitDraft`
- `PetSceneViewAppear`
- `PetSceneUpdateEquipment`
- `DressUpSaveDraft`
- `RouteDressUpSave`
- `RouteDressUpDismiss`

## Loop C: Hatch And Input

Repeat once after a fresh install or reset:

1. Login.
2. Allow Health access.
3. Collect register reward.
4. Hatch pet.
5. Tap pet, type a name, then Save.

Expected signposts:

- `RouteConnectHealthToReward`
- `RouteRegisterRewardToHatch`
- `GIFDecode`
- `NamePetSave`
- `RouteNamePetToDashboard`

## What To Capture

For each hang, record:

- Screen before the hang.
- Last route signpost before the hang.
- Longest signpost interval around the hang.
- Main-thread top stack from Hangs or Time Profiler.
- Whether memory grows after every loop.
