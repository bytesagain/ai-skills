#!/usr/bin/env bash
# component — UI Component Design Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Component-Based Architecture ===

A component is a self-contained, reusable piece of UI with its own
markup, style, and behavior. Components are the atoms of modern UIs.

Core Principles:
  Single Responsibility   Each component does ONE thing well
  Encapsulation           Internal state/DOM hidden from outside
  Composability           Components combine to build complex UIs
  Reusability             Write once, use in many contexts
  Declarative             Describe WHAT, not HOW

Component Anatomy:
  ┌─────────────────────────────┐
  │  Props (input)              │  ← Parent passes data down
  │  ┌───────────────────────┐  │
  │  │  Template / Render    │  │  ← Declares the UI
  │  │  ┌─────────────────┐  │  │
  │  │  │  Children/Slots  │  │  │  ← Composition point
  │  │  └─────────────────┘  │  │
  │  └───────────────────────┘  │
  │  State (internal)           │  ← Component's own data
  │  Events (output)            │  ← Communicates upward
  └─────────────────────────────┘

Data Flow:
  Props flow DOWN:     Parent → Child (read-only for child)
  Events flow UP:      Child → Parent (onClick, onChange, onSubmit)
  Never: Child mutates parent's state directly

Component Types:
  Presentational:  receives data via props, renders UI, no business logic
  Container:       manages state, fetches data, passes to presentational
  Layout:          defines page structure (header, sidebar, grid)
  Utility:         invisible (ErrorBoundary, Portal, Suspense)
  Compound:        group of related components (Select + Option)

The Component Hierarchy:
  App
  ├── Header
  │   ├── Logo
  │   ├── Navigation
  │   └── UserMenu
  ├── MainContent
  │   ├── Sidebar
  │   └── ContentArea
  │       ├── Card
  │       │   ├── CardHeader
  │       │   └── CardBody
  │       └── Card
  └── Footer

Naming Conventions:
  PascalCase: React, Vue (single-file), Angular
  kebab-case: Vue templates, Web Components
  Prefix: design system prefix (ds-button, ui-card)
  Suffix: -View, -Page (for route-level), -Provider (for context)
EOF
}

cmd_propsapi() {
    cat << 'EOF'
=== Props API Design ===

Props are a component's public API. Design them carefully —
they're harder to change later than internal implementation.

Naming Guidelines:
  Boolean props:      is-, has-, should-, can-, with-
    isOpen, hasError, shouldAnimate, canDelete, withBorder
  
  Event handlers:     on- (React) or @/emit (Vue)
    onClick, onClose, onChange, onSubmit
  
  Render/slot props:  render-, -Slot, -Content
    renderHeader, footerSlot, emptyContent
  
  Avoid:              negative booleans (noMargin → hasMargin)
                      generic names (data, info, type)
                      implementation details (useFlexbox)

Type Definitions:

  TypeScript/React:
    interface ButtonProps {
      variant: 'primary' | 'secondary' | 'danger';  // union, not string
      size?: 'sm' | 'md' | 'lg';                     // optional
      disabled?: boolean;                              // default: false
      onClick: (event: MouseEvent) => void;           // required callback
      children: React.ReactNode;                       // content
      className?: string;                              // escape hatch
      icon?: React.ComponentType<IconProps>;           // component prop
    }

  Vue:
    defineProps({
      variant: { type: String, required: true, validator: v => 
        ['primary', 'secondary', 'danger'].includes(v) },
      size: { type: String, default: 'md' },
      disabled: { type: Boolean, default: false },
    })

Defaults:
  Every optional prop should have a sensible default.
  Document the default value in types AND documentation.
  Avoid undefined as default — prefer explicit values.

Prop Patterns:
  Polymorphic "as" prop:
    <Button as="a" href="/link">  → renders as <a>
    <Box as="section">            → renders as <section>
  
  Spread/rest props:
    const { variant, ...rest } = props;
    <button {...rest} className={...}>  → passes all HTML attrs

  Controlled vs Uncontrolled:
    Controlled:   value + onChange (parent owns state)
    Uncontrolled: defaultValue (component owns state)
    Support BOTH for flexibility

API Size Rule:
  5 props: simple, easy to learn → ideal for most components
  10 props: moderate, needs documentation
  15+ props: too complex → split into sub-components
EOF
}

cmd_composition() {
    cat << 'EOF'
=== Composition Patterns ===

1. Children/Slots (simplest):
  React:
    <Card>
      <h2>Title</h2>
      <p>Content goes here</p>
    </Card>
    // Card renders: <div className="card">{children}</div>
  
  Vue:
    <Card>
      <template #header>Title</template>
      <template #default>Content</template>
      <template #footer>Footer</template>
    </Card>

2. Compound Components:
  Components that work together, sharing implicit state.
  
    <Select value={selected} onChange={setSelected}>
      <Select.Trigger>Pick one</Select.Trigger>
      <Select.Content>
        <Select.Item value="a">Option A</Select.Item>
        <Select.Item value="b">Option B</Select.Item>
      </Select.Content>
    </Select>
  
  Implementation: React Context shared between parent/children
  Users: Radix UI, Headless UI, Reach UI

3. Render Props:
  Pass a function that returns JSX.
  
    <DataFetcher url="/api/users" render={(data, loading) => (
      loading ? <Spinner /> : <UserList users={data} />
    )} />
  
  Or as children:
    <Mouse>
      {({ x, y }) => <Cursor x={x} y={y} />}
    </Mouse>
  
  Declining usage: hooks replaced most render prop use cases.

4. Higher-Order Components (HOC):
  Function that wraps a component with extra behavior.
  
    const withAuth = (Component) => {
      return (props) => {
        if (!isAuthed) return <Login />;
        return <Component {...props} />;
      };
    };
    export default withAuth(Dashboard);
  
  Declining: hooks are simpler, HOCs create wrapper hell.

5. Headless Components (behavior only):
  Provide logic + state + ARIA, zero styling.
  Consumer provides all visual rendering.
  
    const { isOpen, toggle, triggerProps, contentProps } = useDisclosure();
    <button {...triggerProps}>Menu</button>
    {isOpen && <div {...contentProps}>...</div>}
  
  Examples: React Aria, Headless UI, Radix Primitives, Downshift

6. Provider/Consumer (Context):
  Share data across component tree without prop drilling.
  
    <ThemeProvider theme="dark">
      <App />   // Any descendant can useTheme()
    </ThemeProvider>
  
  Use for: theme, locale, auth, feature flags
  Avoid for: frequently changing data (performance)
EOF
}

cmd_lifecycle() {
    cat << 'EOF'
=== Component Lifecycle ===

React (Hooks):
  Mount:
    useEffect(() => {
      // runs after first render (componentDidMount)
      return () => { /* cleanup on unmount */ };
    }, []);  // empty deps = mount only
  
  Update:
    useEffect(() => {
      // runs after every render where deps changed
    }, [dep1, dep2]);
  
  Unmount:
    // cleanup function in useEffect
    useEffect(() => {
      const id = setInterval(tick, 1000);
      return () => clearInterval(id);  // cleanup!
    }, []);
  
  Render: function body runs on every render
  Memoize: useMemo (values), useCallback (functions), React.memo (components)

React (Class — legacy):
  constructor → getDerivedStateFromProps → render
  → componentDidMount → (updates) → componentDidUpdate
  → componentWillUnmount
  → componentDidCatch (error boundary)

Vue 3 (Composition API):
  onBeforeMount()   Before DOM insertion
  onMounted()       DOM is ready, refs available
  onBeforeUpdate()  Before reactive data re-renders
  onUpdated()       After re-render complete
  onBeforeUnmount() Before teardown (cleanup timers, listeners)
  onUnmounted()     Component removed from DOM
  
  // Equivalent to React's useEffect:
  watchEffect(() => { ... })
  watch(source, (newVal, oldVal) => { ... })

Svelte:
  onMount(() => {
    // DOM ready
    return () => { /* cleanup */ };
  });
  onDestroy(() => { /* cleanup */ });
  beforeUpdate(() => { /* before DOM update */ });
  afterUpdate(() => { /* after DOM update */ });
  
  Reactive: $: statement (runs whenever dependencies change)

Common Lifecycle Patterns:
  Fetch data on mount:    useEffect + fetch + setState
  Subscribe/unsubscribe:  useEffect return cleanup
  Debounce input:         useEffect with timer + cleanup
  Intersection observer:  useEffect + IntersectionObserver + cleanup
  Window resize:          useEffect + addEventListener + cleanup

Anti-patterns:
  ✗ Fetch in render body (causes infinite re-renders)
  ✗ Missing cleanup (memory leaks, stale subscriptions)
  ✗ Missing dependencies in useEffect dep array
  ✗ setState in useEffect without condition (infinite loop)
EOF
}

cmd_statemgmt() {
    cat << 'EOF'
=== Component State Management ===

State Location Decision Tree:
  Does only ONE component use it?
    → Local state (useState, ref(), $state)
  
  Do SIBLINGS need it?
    → Lift state to parent, pass down as props
  
  Do DISTANT components need it?
    → Context/provide-inject (if rarely changes)
    → State management library (if frequently changes)
  
  Is it URL state?
    → URL search params / route params
  
  Is it server state?
    → React Query / SWR / Apollo (not local state!)

Controlled vs Uncontrolled:

  Controlled (parent owns state):
    <Input value={name} onChange={setName} />
    Parent: full control, validation, transformation
    Use when: form validation, dependent fields, complex logic
  
  Uncontrolled (component owns state):
    <Input defaultValue="hello" ref={inputRef} />
    Component: manages internally, parent reads via ref
    Use when: simple forms, file inputs, third-party integration
  
  Support Both (best practice for libraries):
    function Input({ value, defaultValue, onChange }) {
      const [internal, setInternal] = useState(defaultValue);
      const isControlled = value !== undefined;
      const currentValue = isControlled ? value : internal;
      // ...
    }

State Colocation:
  Keep state as CLOSE as possible to where it's used.
  
  Bad:  global store for a modal's open/close state
  Good: local state in the component that owns the modal
  
  Bad:  context for a form's field values
  Good: local state in the form component, props to fields

Derived State:
  If you can COMPUTE it, don't store it.
  
  Bad:
    const [items, setItems] = useState([...]);
    const [count, setCount] = useState(items.length); // duplicated!
  
  Good:
    const [items, setItems] = useState([...]);
    const count = items.length;  // derived, always in sync

Server State vs Client State:
  Server State (TanStack Query / SWR):
    Cached, has loading/error states, auto-refetches
    Examples: user profile, product list, notifications
  
  Client State (useState / Zustand / Pinia):
    Synchronous, UI-specific, doesn't persist
    Examples: modal open, selected tab, sidebar collapsed
  
  Don't mix them! Use the right tool for each.
EOF
}

cmd_accessibility() {
    cat << 'EOF'
=== Accessible Component Patterns ===

ARIA Roles for Common Components:
  Button:      role="button", tabindex="0"
  Link:        <a href="..."> (semantic, no role needed)
  Dialog:      role="dialog", aria-modal="true", aria-labelledby
  Tab:         role="tablist" > role="tab" + role="tabpanel"
  Menu:        role="menu" > role="menuitem"
  Combobox:    role="combobox" + role="listbox" > role="option"
  Alert:       role="alert" (live region, announced immediately)
  Tooltip:     role="tooltip", aria-describedby on trigger

Keyboard Navigation Patterns:

  Button: Enter/Space to activate
  Dialog: Tab cycles within dialog, Escape closes
  Tabs:   Arrow keys switch tabs, Tab enters panel
  Menu:   Arrow keys navigate, Enter selects, Escape closes
  Combobox: Arrow keys navigate list, Enter selects
  
  Focus Trap (dialogs, modals):
    Tab from last focusable → first focusable (cycle)
    Shift+Tab from first → last (reverse cycle)
    Escape → close and return focus to trigger

Focus Management:
  Opening dialog:    focus first focusable element inside
  Closing dialog:    return focus to trigger element
  Deleting item:     focus next item or previous
  Route change:      focus main content or heading
  Error:             focus first invalid field

  // Save and restore focus
  const trigger = document.activeElement;
  openDialog();
  // ... user interacts ...
  closeDialog();
  trigger.focus(); // restore!

Live Regions:
  aria-live="polite"       Announced when user is idle
  aria-live="assertive"    Announced immediately (interrupts)
  
  Use for: toast notifications, form errors, loading states
  
  <div aria-live="polite" aria-atomic="true">
    {statusMessage}
  </div>

Color and Contrast:
  WCAG AA: 4.5:1 for normal text, 3:1 for large text
  WCAG AAA: 7:1 for normal text, 4.5:1 for large text
  Never use color as the ONLY indicator (add icons, patterns)
  Focus indicator: visible, high contrast, at least 2px

Form Accessibility:
  <label htmlFor="email">Email</label>
  <input id="email" aria-describedby="email-help email-error" />
  <span id="email-help">We'll never share your email</span>
  <span id="email-error" role="alert">Invalid email</span>
  
  Required: aria-required="true"
  Invalid: aria-invalid="true"
  Disabled: aria-disabled="true" (or native disabled)
EOF
}

cmd_testing() {
    cat << 'EOF'
=== Component Testing ===

Testing Pyramid for Components:
  ▲ E2E (Cypress, Playwright)     Few, slow, full integration
  ■ Integration (Testing Library)  Core interactions, user flows
  ■■■ Unit (Jest, Vitest)          Props→render, utility functions

Testing Library Philosophy:
  "Test the way users interact, not implementation details."
  
  ✓ getByRole('button', { name: 'Submit' })   → what users see
  ✗ getByTestId('submit-btn')                  → implementation detail
  ✗ wrapper.instance().state.isOpen             → internal state

  Query Priority:
    1. getByRole       (accessible role + name)
    2. getByLabelText  (form fields)
    3. getByText       (visible text)
    4. getByAltText    (images)
    5. getByTestId     (last resort)

Unit Test Patterns:

  Rendering:
    it('renders with default props', () => {
      render(<Button>Click me</Button>);
      expect(screen.getByRole('button')).toHaveTextContent('Click me');
    });
  
  Props:
    it('applies variant class', () => {
      render(<Button variant="danger">Delete</Button>);
      expect(screen.getByRole('button')).toHaveClass('btn-danger');
    });
  
  Events:
    it('calls onClick when clicked', async () => {
      const onClick = vi.fn();
      render(<Button onClick={onClick}>Go</Button>);
      await userEvent.click(screen.getByRole('button'));
      expect(onClick).toHaveBeenCalledTimes(1);
    });
  
  Conditional rendering:
    it('shows error when invalid', () => {
      render(<Input error="Required" />);
      expect(screen.getByRole('alert')).toHaveTextContent('Required');
    });

Visual Regression Testing:
  Storybook + Chromatic: snapshot every component state
  Percy: visual diff on pull requests
  Playwright: screenshot comparison
  
  Each component story = one visual state:
    Default, Hover, Focus, Active, Disabled, Loading, Error

Storybook Best Practices:
  One story per meaningful state
  Use args for dynamic props
  Include edge cases: empty, loading, error, overflow
  Document: usage examples, do's and don'ts
  Accessibility addon: check a11y in each story
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Common Component Patterns ===

Modal / Dialog:
  Props: isOpen, onClose, title, children
  Behavior: focus trap, Escape to close, click-outside to close
  Portal: render outside DOM hierarchy (avoid z-index issues)
  ARIA: role="dialog", aria-modal, aria-labelledby
  Animation: enter/exit transitions
  Scroll lock: prevent body scroll when open

Dropdown / Select:
  Props: options, value, onChange, placeholder
  Behavior: arrow key navigation, type-ahead search
  Positioning: floating-ui/popper for smart placement
  ARIA: role="listbox" + role="option", aria-expanded
  Close on: Escape, click outside, selection
  Virtual scroll: for 1000+ options

Form Field (wrapper):
  Props: label, error, hint, required, children (the input)
  Wires: htmlFor ↔ id, aria-describedby, aria-invalid
  Layout: label above, input, hint below, error below
  
  <FormField label="Email" error={errors.email} required>
    <Input type="email" {...register('email')} />
  </FormField>

Data Table:
  Props: columns, data, sortable, selectable, pagination
  Behavior: column sorting, row selection, pagination
  Virtual scroll: for 10,000+ rows (TanStack Virtual)
  ARIA: role="table", scope="col", aria-sort
  Responsive: horizontal scroll or card layout on mobile

Toast / Notification:
  Props: message, type (success/error/info), duration
  Behavior: auto-dismiss after duration, manual dismiss
  Queue: stack multiple toasts, remove oldest
  ARIA: role="alert", aria-live="polite"
  Position: top-right, bottom-center (configurable)
  Animation: slide in, fade out

Tabs:
  Props: tabs (label + content), activeTab, onChange
  Behavior: arrow keys switch, Home/End jump
  ARIA: role="tablist" > role="tab" + role="tabpanel"
  Lazy: only render active panel (or all + hidden)
  
  <Tabs>
    <TabList>
      <Tab>Profile</Tab>
      <Tab>Settings</Tab>
    </TabList>
    <TabPanels>
      <TabPanel>Profile content</TabPanel>
      <TabPanel>Settings content</TabPanel>
    </TabPanels>
  </Tabs>

Accordion:
  Props: items (title + content), allowMultiple
  Behavior: click to toggle, one or many open
  ARIA: role="button" + aria-expanded + aria-controls
  Animation: height transition (measure then animate)
EOF
}

show_help() {
    cat << EOF
component v$VERSION — UI Component Design Reference

Usage: script.sh <command>

Commands:
  intro         Component architecture principles
  propsapi      Props design: naming, types, defaults
  composition   Slots, render props, compound, HOC, headless
  lifecycle     Mount/update/unmount in React, Vue, Svelte
  statemgmt     Local, lifted, context, controlled/uncontrolled
  accessibility ARIA roles, keyboard navigation, focus management
  testing       Unit, integration, visual regression, Storybook
  patterns      Modal, dropdown, form field, table, toast, tabs
  help          Show this help
  version       Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    propsapi)      cmd_propsapi ;;
    composition)   cmd_composition ;;
    lifecycle)     cmd_lifecycle ;;
    statemgmt)     cmd_statemgmt ;;
    accessibility) cmd_accessibility ;;
    testing)       cmd_testing ;;
    patterns)      cmd_patterns ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "component v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
