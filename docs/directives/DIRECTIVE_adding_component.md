# Directive: Adding a JavaScript Component

> **Applies to:** Theme/Extension (Archetype D)
> **Complexity:** Medium to High
> **Typical files touched:** 2-3 (JS file, Liquid template, optional events.js)

## Structural Pattern

### What This Pattern Does

Creates an interactive Web Component (custom HTML element) that enhances server-rendered HTML. Components handle client-side interactivity like form submission, dynamic updates, animations, and user interactions.

### Why This Pattern Exists

JavaScript components enable:
- **Progressive enhancement:** HTML works without JS; JS makes it better
- **Encapsulation:** Component logic is self-contained
- **Reusability:** Same component works wherever the custom element appears
- **Lifecycle management:** `connectedCallback`/`disconnectedCallback` for setup/cleanup
- **Declarative usage:** Use as HTML element in Liquid templates

### When to Apply This Pattern

**Signals that trigger this pattern:**
- Need client-side interactivity (click handlers, form submission, animations)
- Feature requires JavaScript APIs (Fetch, IntersectionObserver, etc.)
- Component manages local state or UI updates
- Need to respond to or dispatch theme events

**Signals that this pattern does NOT apply:**
- Pure styling (use CSS)
- Static content (use Liquid only)
- One-off scripts (consider inline script or utility function)
- Server-side logic (use Liquid)

## Concrete Example

### Context

The `quantity-selector-component` handles quantity input with increment/decrement buttons and dispatches events when the value changes.

### Implementation

**File: `assets/quantity-selector.js`**

```javascript
import { Component } from './component.js';
import { QuantitySelectorUpdateEvent } from './events.js';

class QuantitySelectorComponent extends Component {
  /**
   * Required refs that must exist in the component's DOM
   * @type {string[]}
   */
  requiredRefs = ['input', 'increment', 'decrement'];

  /**
   * Called when element is added to DOM
   */
  connectedCallback() {
    super.connectedCallback();

    this.min = parseInt(this.refs.input.min) || 1;
    this.max = parseInt(this.refs.input.max) || Infinity;
    this.step = parseInt(this.refs.input.step) || 1;

    this.refs.increment.addEventListener('click', this.handleIncrement.bind(this));
    this.refs.decrement.addEventListener('click', this.handleDecrement.bind(this));
    this.refs.input.addEventListener('change', this.handleChange.bind(this));
  }

  /**
   * Called when element is removed from DOM
   */
  disconnectedCallback() {
    super.disconnectedCallback();
    // Event listeners are automatically cleaned up when element is removed
  }

  /**
   * Get current quantity value
   * @returns {number}
   */
  get value() {
    return parseInt(this.refs.input.value) || this.min;
  }

  /**
   * Set quantity value with bounds checking
   * @param {number} newValue
   */
  set value(newValue) {
    const clampedValue = Math.max(this.min, Math.min(this.max, newValue));
    this.refs.input.value = clampedValue;
    this.updateButtonStates();
    this.dispatchUpdateEvent();
  }

  /**
   * Handle increment button click
   */
  handleIncrement() {
    this.value = this.value + this.step;
  }

  /**
   * Handle decrement button click
   */
  handleDecrement() {
    this.value = this.value - this.step;
  }

  /**
   * Handle direct input change
   */
  handleChange() {
    this.value = this.value; // Triggers clamping and event dispatch
  }

  /**
   * Update disabled state of increment/decrement buttons
   */
  updateButtonStates() {
    this.refs.decrement.disabled = this.value <= this.min;
    this.refs.increment.disabled = this.value >= this.max;
  }

  /**
   * Dispatch quantity update event
   */
  dispatchUpdateEvent() {
    const cartLine = this.dataset.cartLine;
    this.dispatchEvent(new QuantitySelectorUpdateEvent(this.value, cartLine));
  }
}

// Register the custom element
customElements.define('quantity-selector-component', QuantitySelectorComponent);
```

**File: `snippets/quantity-selector.liquid`**

```liquid
{%- liquid
  assign value = value | default: 1
  assign min = min | default: 1
  assign max = max | default: 99
  assign cart_line = cart_line | default: nil
-%}

<quantity-selector-component
  class="quantity-selector"
  {% if cart_line %}data-cart-line="{{ cart_line }}"{% endif %}
>
  <button
    type="button"
    ref="decrement"
    class="quantity-selector__button"
    aria-label="{{ 'accessibility.decrease_quantity' | t }}"
  >
    {% render 'icon-minus' %}
  </button>

  <input
    ref="input"
    type="number"
    class="quantity-selector__input"
    value="{{ value }}"
    min="{{ min }}"
    max="{{ max }}"
    step="1"
    aria-label="{{ 'accessibility.quantity' | t }}"
  >

  <button
    type="button"
    ref="increment"
    class="quantity-selector__button"
    aria-label="{{ 'accessibility.increase_quantity' | t }}"
  >
    {% render 'icon-plus' %}
  </button>
</quantity-selector-component>
```

### How the Pattern Was Applied

1. Created class extending `Component` base class
2. Defined `requiredRefs` for DOM element access
3. Implemented `connectedCallback` for initialization
4. Used `this.refs.*` to access elements with `ref` attributes
5. Dispatched custom event for cross-component communication
6. Registered custom element with `customElements.define()`
7. Created Liquid snippet that renders the custom element HTML
8. Added `ref` attributes to elements that JS needs to access

## Transfer Recipe

### Prerequisites

- [ ] Clear understanding of what interactivity is needed
- [ ] List of DOM elements the component needs to access
- [ ] Events the component will dispatch or listen to
- [ ] Liquid template structure planned

### Steps

1. **Create the component file**
   - Create `assets/[component-name].js`
   - Use kebab-case matching the custom element name

2. **Import dependencies**
   ```javascript
   import { Component } from './component.js';
   // Import event classes if dispatching events
   import { SomeEvent } from './events.js';
   ```

3. **Define the component class**
   ```javascript
   class MyComponent extends Component {
     // Optional: list required ref elements
     requiredRefs = ['button', 'input'];

     connectedCallback() {
       super.connectedCallback(); // Always call super
       // Initialization code
     }

     disconnectedCallback() {
       super.disconnectedCallback();
       // Cleanup code (usually not needed - listeners auto-cleanup)
     }
   }
   ```

4. **Register the custom element**
   ```javascript
   customElements.define('my-component', MyComponent);
   ```
   - Name must contain a hyphen (Web Components requirement)
   - Convention: `[name]-component` suffix

5. **Create Liquid template**
   - Wrap content in custom element tag
   - Add `ref="name"` attributes to elements JS needs
   - Include accessibility attributes (aria-labels, roles)

6. **Load the script**
   - Scripts are typically loaded via `{% render 'scripts' %}` in layout
   - Or add module script directly:
   ```liquid
   <script type="module" src="{{ 'my-component.js' | asset_url }}"></script>
   ```

7. **Add event handling** (if communicating with other components)
   - Define new event class in `events.js` if needed
   - Dispatch: `this.dispatchEvent(new MyEvent(data))`
   - Listen: `document.addEventListener(ThemeEvents.myEvent, handler)`

### Verification

- [ ] Component initializes when element is added to DOM
- [ ] `this.refs` contains expected elements
- [ ] Event listeners work correctly
- [ ] Component cleans up properly when removed
- [ ] Works after Section Rendering API updates (morphing)
- [ ] Fallback behavior works if JS fails

### Common Mistakes

- **Forgetting `super.connectedCallback()`:** Base class initialization won't run
- **Missing `ref` attributes in HTML:** `this.refs` will be empty
- **Not using custom element naming convention:** Must contain hyphen
- **Querying DOM directly instead of using refs:** Breaks with Shadow DOM
- **Not handling dynamic DOM:** Use mutation observers (base class provides)
- **Blocking main thread:** Use `requestIdleCallback` for non-critical work

## Component Lifecycle

```
┌─────────────────────────────────────────────────────────────────┐
│ 1. HTML parsed, custom element encountered                      │
│    └── constructor() called (don't do DOM work here)           │
│                                                                  │
│ 2. Element added to document                                    │
│    └── connectedCallback()                                      │
│        ├── super.connectedCallback() - hydrates shadow DOM     │
│        ├── this.refs populated from ref attributes             │
│        └── Your initialization code                             │
│                                                                  │
│ 3. Section Rendering API updates the DOM                        │
│    └── updatedCallback()                                        │
│        └── Refs are refreshed, state preserved                  │
│                                                                  │
│ 4. Element removed from document                                │
│    └── disconnectedCallback()                                   │
│        └── Cleanup (mutation observer auto-disconnects)         │
└─────────────────────────────────────────────────────────────────┘
```

## Related Documents

- [ADR_001_web_components_over_frameworks.md](../adr/ADR_001_web_components_over_frameworks.md) — Why Web Components
- [ADR_004_event_driven_component_communication.md](../adr/ADR_004_event_driven_component_communication.md) — Event patterns
- [PLATFORM_CONVENTIONS.md](../PLATFORM_CONVENTIONS.md#javascript-component-pattern) — Component patterns
- [DOMAIN_GLOSSARY.md](../DOMAIN_GLOSSARY.md#component-javascript) — Component terminology
- `assets/component.js` — Base Component class
- `assets/events.js` — Theme event definitions
