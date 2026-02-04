# ADR 004: Event-Driven Component Communication

> **Status:** Accepted
> **Date:** 2024-01-01 (Retroactive documentation of founding decision)
> **Deciders:** Shopify Theme Team
> **Applies to:** Theme/Extension (Archetype D)

## Context

The Horizon theme contains multiple independent Web Components that need to communicate:

- **Variant picker** → **Product form** (selected variant changes)
- **Add to cart button** → **Cart drawer** (item added)
- **Cart drawer** → **Header cart icon** (count updated)
- **Media gallery** → **Zoom dialog** (media selected)
- **Quantity selector** → **Cart line item** (quantity changed)
- **Filter facets** → **Collection grid** (filters applied)

Communication requirements:
- Components are in different DOM locations (not parent-child)
- Components may be added/removed dynamically (section rendering)
- Multiple components may need to react to the same event
- Events should be debuggable and traceable

Options considered:
1. **Direct references:** Components hold references to each other
2. **Global state store:** Centralized state (Redux-like)
3. **DOM events:** Native CustomEvents bubbling through DOM
4. **Pub/sub library:** External event bus library

## Decision

We use **native DOM CustomEvents** with a standardized `ThemeEvents` namespace for all cross-component communication.

Architecture:
1. `ThemeEvents` class defines event name constants
2. Custom event classes (`VariantUpdateEvent`, `CartUpdateEvent`, etc.) encapsulate payloads
3. Events dispatch on `document` and bubble
4. Components listen with `document.addEventListener()`

```javascript
// assets/events.js
export class ThemeEvents {
  static variantSelected = 'variant:selected';
  static variantUpdate = 'variant:update';
  static cartUpdate = 'cart:update';
  static cartError = 'cart:error';
  // ...
}

export class VariantUpdateEvent extends Event {
  constructor(resource, sourceId, data) {
    super(ThemeEvents.variantUpdate, { bubbles: true });
    this.detail = { resource, sourceId, data };
  }
}
```

```javascript
// Dispatching an event
this.dispatchEvent(new VariantUpdateEvent(variant, this.id, { html, productId }));

// Listening for an event
document.addEventListener(ThemeEvents.variantUpdate, (event) => {
  const { resource, sourceId, data } = event.detail;
  // React to variant update
});
```

## Consequences

### Benefits

- **Native platform:** Uses browser's event system, no library needed
- **Loose coupling:** Components don't need references to each other
- **Discoverable:** Events are visible in DevTools Event Listeners panel
- **Typed payloads:** Event classes define expected data structure
- **Bubbling:** Events can be caught at any DOM level
- **Debuggable:** `console.log` in listeners shows event flow
- **Standard pattern:** Familiar to any JavaScript developer

### Costs

- **No guaranteed delivery:** If no listener exists, event is lost
- **Manual cleanup:** Listeners must be removed to prevent memory leaks
- **String-based:** Typos in event names fail silently
- **No time travel:** Unlike Redux, can't replay/undo events
- **Global namespace:** All events share document, potential conflicts

### Neutral Effects

- Testing requires dispatching/listening to events (same as any approach)
- Performance is equivalent to alternatives for this scale
- Works with or without Shadow DOM

## Alternatives Considered

### Direct Component References

- **Description:** Components query DOM to find each other, call methods directly
- **Why rejected:**
  - Tight coupling between components
  - Breaks when DOM structure changes
  - Hard to add new listeners
  - Difficult with dynamically added components

### Global State Store (Redux-like)

- **Description:** Centralized state object, components subscribe to changes
- **Why rejected:**
  - Adds library dependency
  - Overkill for communication needs (not complex state)
  - State synchronization with server-rendered HTML is complex
  - Learning curve for store patterns

### Pub/Sub Library

- **Description:** External event bus library (e.g., mitt, EventEmitter3)
- **Why rejected:**
  - Native events are sufficient
  - Adds dependency for minimal benefit
  - Loses DOM-based debugging tools
  - Another abstraction to learn

## Event Reference

| Event | Dispatched By | Consumed By | Payload |
|-------|---------------|-------------|---------|
| `variant:selected` | variant-picker | product-form, media-gallery | `{ resource: { id } }` |
| `variant:update` | product-form | All variant-aware components | `{ resource, sourceId, data: { html, productId } }` |
| `cart:update` | cart operations | cart-drawer, header, product-cards | `{ resource, sourceId, data: { itemCount, sections } }` |
| `cart:error` | cart operations | cart-drawer, product-form | `{ sourceId, data: { message, errors } }` |
| `filter:update` | facets | collection-grid | `{ queryParams }` |
| `slideshow:select` | slideshow | thumbnails, indicators | `{ index, slide, trigger }` |

## Validation

**Signals that this decision is succeeding:**
- Components communicate reliably across DOM boundaries
- New components integrate easily by listening to existing events
- Event flow is traceable in DevTools
- No event-related memory leaks

**Signals that this decision should be revisited:**
- Event coordination becomes too complex (need sagas/middleware)
- Performance issues from too many listeners
- Need for guaranteed delivery or retry logic
- State management needs exceed communication

## Related

- [ADR_001_web_components_over_frameworks.md](ADR_001_web_components_over_frameworks.md) — Component architecture
- [PLATFORM_CONVENTIONS.md](../PLATFORM_CONVENTIONS.md#event-communication) — Event patterns
- [DOMAIN_GLOSSARY.md](../DOMAIN_GLOSSARY.md#theme-events) — ThemeEvents terminology
- `assets/events.js` — Event definitions
- `assets/product-form.js` — Example event dispatching
- `assets/cart-drawer.js` — Example event handling
