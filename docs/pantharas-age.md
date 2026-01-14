# Pantharas Age - Technical Documentation

## Table of Contents
- [Overview](#overview)
- [Project Scope](#project-scope)
- [Implemented Systems](#implemented-systems)
  - [Camera Shake System](#camera-shake-system)
  - [Crouch & Crawl System](#crouch--crawl-system)
  - [NPC Dialogue System](#npc-dialogue-system)
  - [Lightning Strike Ability](#lightning-strike-ability)
- [Media & Showcases](#media--showcases)
- [Notes on Reusability](#notes-on-reusability)

## Overview

**Pantharas Age** is an open-world RPG playable prototype developed in Roblox, focused on exploration, systemic gameplay design, player immersion, and progression.  
The project was created as an independent design and programming exercise, with emphasis on modular systems and reusable mechanics.

---

## Project Scope

This documentation focuses on the **core gameplay systems implemented for Pantharas Age**, showcasing how each mechanic is structured, configured, and integrated within Roblox Studio.

All project-specific scripts are tagged with the **[PA]** prefix for clarity.

---

## Implemented Systems

### 📷 Camera Shake System <a id="camera-shake-system"></a>
**Script:** `[PA]Cam_Shake_Script.lua`

A camera feedback system designed to enhance realism by introducing subtle camera movement while the player walks and moves through the environment.

- Compact, simple and adjustable
- Improves player presence and environmental weight
- Active across the entire game experience

📌 *Note:*  
This system does not have a dedicated showcase video, as its effect is present in all Pantharas Age gameplay footage.

**Setup:**
The system setup within Roblox Studio consists of a single `LocalScript` placed inside  
`StarterPlayer > StarterCharacterScripts`, as shown below.
![Camera Shake Setup](assets/setups/pantharas-age/CamShakeSetup.png)

---

### 🧍 Crouch & Crawl System <a id="crouch--crawl-system"></a>
**Script:** `[PA]CrouchCrawl_Script.lua`

A player movement state system allowing seamless transitions between standing, crouching, and crawling states.

- `C` key input → move down one state  
- `X` key input → move up one state
- Designed to support traversal, and environmental interaction

**Setup:**
This system is configured as a `LocalScript` under `StarterPack`, referencing separate `Animation` assets for crouching and crawling, as illustrated below.
![Crouch & Crawl Setup](assets/setups/pantharas-age/CrouchCrawlSetup.png)

🎥 **Video Showcase:**  
[Vimeo – Crouch & Crawl System](https://vimeo.com/1153077635)

---

### 💬 NPC Dialogue System <a id="npc-dialogue-system"></a>
**Script:** `[PA]NPC_Chat_Script.lua`

A modular dialogue system that enables NPC interaction through configurable dialogue data and UI elements.

- Supports multiple dialogue entries per NPC
- Easily extendable for quest or branching dialogue systems
- Decouples dialogue content from NPC logic

**System Logic Setup:**
This system is implemented as a `ScreenGui` located in `StarterGui`, containing the required audio assets, logic scripts, and UI elements.  
The visual interface is composed of two `TextLabel` components, as shown below.
![NPC Chat System Setup](assets/setups/pantharas-age/BackendChatSetup.png)

**Dialogue Configuration per NPC:**
For this system to function correctly, each interactable NPC must include a `Folder` within Roblox Studio containing all dialogue entries as `StringValue` objects.  
Each `StringValue` should be named according to its order in the dialogue sequence, as shown below.
![NPC Dialogue Setup](assets/setups/pantharas-age/NPCSetup.png)

🎥 **Video Showcase:**  
[Vimeo – NPC Dialogue System](https://vimeo.com/1153076272)

---

### ⚡ Lightning Strike Ability <a id="lightning-strike-ability"></a>
**Script:** `LightningStrike.lua`

A gameplay ability that triggers a lightning storm effect, originally implemented for Pantharas Age and later reused in [**Cruzaders Madness Classic**](docs/cruzaders-madness-classic.md).

- Uses a LocalScript, ServerScript, and RemoteEvent architecture
- Designed for reuse across different projects
- Demonstrates cross-project system portability

🎥 **Video Showcase:**  
[Vimeo – Pantharas Age Lightning Strike Ability](https://vimeo.com/1153078867)

📌 *Note:*  
This system is intentionally untagged, as it functions as a shared, project-agnostic gameplay module.

---

## Media & Showcases

All video showcases are hosted on **Vimeo** and demonstrate real in-engine gameplay using the documented systems.

---

## Notes on Reusability

Pantharas Age was designed with system reuse in mind.  
Several mechanics, such as [**Lightning Strike Ability**](#lightning-strike-ability), were later adapted and integrated into other projects without significant refactoring, demonstrating scalable and modular system design.
