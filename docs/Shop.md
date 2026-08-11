# Shop（UTE 码风）

> 参考 sordidtale 流程，按 Kite95 风格实现。打字机**无**商店专用指令。

## 用法

1. `Shop_Custom()` 里 `Shop_Set(id, host, intro, bgm)`；可在此 `Shop_DefineMainTemplate`
2. Overworld：`Shop_Start(id)`（见 `trigger_shop`）
3. Host User Event 0：`Shop_AddBuy` / `Shop_AddTalk`；可选 `Shop_ApplyMainTemplate("geno")`
4. 成交：引擎调 `Shop_TryBuy` / `Shop_TrySell`；host 只读结果写台词

## Host 事件（`SHOP_HOST_EVENT`，对齐 `BATTLE_ENEMY_EVENT`）

| 事件 | User Event | 对应 Battle | 时机 |
|------|------------|-------------|------|
| `INIT` | 0 | `INIT` | 进店初始化；`Shop_AddBuy` / `Shop_AddTalk` |
| `SHOP_START` | 1 | `BATTLE_START` | 主菜单四格出现 |
| `MENU_START` | 2 | `MENU_START` | 进入买/卖/谈子菜单 |
| `MENU_SWITCH` | 3 | `MENU_SWITCH` | 子菜单切换 / 选谈话后 |
| `CHOICE_SWITCH` | 4 | `MENU_CHOICE_SWITCH` | 光标移动 |
| `CONFIRM` | 5 | `MENU_END`* | 买/卖确认后 |
| `DIALOG_START` | 6 | `DIALOG_START` | 旁白开始 |
| `DIALOG_END` | 7 | `DIALOG_END` | 旁白结束 |

\* Battle 为 `MENU_END`；商店成交用 `CONFIRM`。

## Host 常用 API

| API | 作用 |
|-----|------|
| `Shop_AddBuy(item, price, desc*, state*, stock*, display_name*)` | 追加货架；`stock` 默认 **1**；`-1` = 无限；`display_name` 覆盖显示名 |
| `Shop_SetBuy(index, item, price, desc*, state*, stock*, display_name*)` | 整项覆写（`index==length` 时追加） |
| `Shop_PatchBuy(index, {price?, desc?, state?, stock?, display_name?})` | 局部改价/说明/槽位状态/库存/显示名 |
| `Shop_RemoveBuy` / `Shop_ClearBuy` | 删一项 / 清空 |
| `Shop_GetSlotState` / `Shop_GetBuyStock` / `Shop_GetBuyNumber` | 查询 |
| `Shop_AddTalk(name, dialog, flag_key*)` | 对话；`dialog` 可为字符串或数组 |
| `Shop_GetTalkProgress(index)` | 读进度（条件解锁用） |
| `Shop_ApplyMainTemplate` / `Shop_DefineMainTemplate` / `Shop_SetMainChoice` | 主菜单 |
| `Shop_SetMenuDialog` | 主菜单旁白 |
| `Shop_GetBuyResult` / `Shop_GetSellResult` | 成交结果（写反馈） |
| `Shop_GetLastBuyItem` / `Shop_GetLastSellItem` | 最近一次买/卖成交的 item id |

## 货架

| `SHOP_SLOT` | 含义 |
|-------------|------|
| `OPEN` | 可买 / 可拿（free） |
| `LOCKED` | 锁定或展示；**free 也不能拿**。条件到了再 `Shop_PatchBuy` |
| `SOLD_OUT` | 卖完，列表仍在（灰） |

```gml
Shop_AddBuy(ITEM_BANDAGE,15,desc);                    // 默认库存 1，OPEN
Shop_AddBuy(ITEM_STICK,5,desc,SHOP_SLOT.OPEN,2);      // 剩 2
Shop_AddBuy(ITEM_TOY_KNIFE,50,desc,SHOP_SLOT.LOCKED);
Shop_AddBuy(ITEM_BANDAGE,15,desc,SHOP_SLOT.OPEN,-1);  // 无限
Shop_PatchBuy(5,{display_name:"Mystery Box"});        // 货架显示名覆盖
// 条件解锁：
Shop_PatchBuy(2,{state:SHOP_SLOT.OPEN,desc:unlocked_desc});
```

`Shop_TryBuy` 成功且 `stock>=0` 时扣库存并写入 static；到 0 → `SOLD_OUT`。Take/free 同样扣。点选 `SOLD_OUT` 项 → `SHOP_BUY_RESULT.SOLD_OUT`（host 写售罄台词）。

购买/谈话列表 **超过 4 项**（即 `GetBuyPageMax` / `GetTalkPageMax` > 1）时，页码由独立 `text_typer` 显示；仅一页时不显示页码。

存档键：`{店主短名}_stock_{货架序号}`（如 `demo_stock_1`）；`-1` 无限不占键。`AddBuy`/`SetBuy` 后自动加载。

出售：道具实现 `GetShopSellPrice()`；未定义或 ≤0 不可卖，列表显示 `{refuse}G`（默认 `不！` / `NO!`）。Host Create 可设 `_sell_refuse_text`。

## 对话（新）

`Shop_AddTalk(name, dialog)`：

- **字符串**：单段
- **字符串数组**：多段；未读后续段黄字 + `shop.menu.talk.new`
- 可选第 3 参 `flag_key`；默认 `{店主短名}_talk_{序号}`

进度（static）：`0` 从未 → 奇数 =（新）未读 → 偶数 = 已读（并可兼下一段的新）。

```gml
Shop_AddTalk("About", [
	"* First time.",
	"* Second time — was NEW."
]);
// 读完第一段后 progress == 2
```

## 主菜单模板

进店默认 `"default"`（买/卖/谈/走）。

| 动作 | 行为 |
|------|------|
| `BUY` | 购买；`free:true` = 拿取（0G）。仅 `SHOP_SLOT.OPEN` |
| `SELL` / `TALK` / `EXIT` | 出售 / 对话列表 / 离开 |
| `DIALOG` | 播一段字再回主菜单；副作用用打字机（如 `{gold 50}`） |

```gml
if(Player_GetKills()>=N){
	Shop_ApplyMainTemplate("geno");
	Shop_PatchBuy(3,{state:SHOP_SLOT.OPEN});
}
```

自定义模板在 `Shop_Custom`：`Shop_DefineMainTemplate("name", slots[4])`。槽位：`action`，`label`/`label_key`，`free`（BUY），`dialog`/`dialog_key`（DIALOG）。

## Demo

商店 id `0` → `shop_host_demo`。Bandage×1、Stick×2、Ribbon（Talk 解锁）、Knife（展示 / geno 可拿）。

## 文件

- `Shop.gml` — 注册 / 状态 / 对话框
- `Shop_Catalog.gml` — 货架 / 对话 / 库存存档 / TryBuy·TrySell
- `Shop_Menu.gml` — 主菜单模板与各页 UI
- `Shop_Custom.gml` + `Macro_Shop.gml`
- 对象：`shop` / `shop_ui` / `shop_ui_itemdesc` / `shop_host` / `shop_host_demo` / `trigger_shop`
- 文案：`datafiles/locale/*/string/shop.json`
