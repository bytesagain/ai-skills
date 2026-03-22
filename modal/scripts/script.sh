#!/usr/bin/env bash
# modal — Modal Dialog Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Modal Dialogs ===

A modal dialog is an overlay that requires user interaction before
returning to the main content. It blocks access to the rest of the page.

Modal vs Modeless:
  Modal:     Blocks background interaction. User MUST respond.
             Examples: confirmation, login, critical error
  Modeless:  Background remains interactive. User CAN ignore.
             Examples: find & replace, chat widget, inspector

When to Use Modals:
  ✓ Confirmation of destructive actions ("Delete this item?")
  ✓ Collecting required input (login, 2FA code)
  ✓ Displaying critical information (errors, warnings)
  ✓ Step-by-step wizards that need focus
  ✓ Previewing content (lightbox, image zoom)

When NOT to Use Modals:
  ✗ Displaying non-critical information (use toast/notification)
  ✗ Long forms (use a dedicated page instead)
  ✗ Navigation menus (use drawers or dropdowns)
  ✗ Marketing/promotional content (users hate surprise modals)
  ✗ On page load (especially on mobile)
  ✗ Nested modals (modal opening another modal = bad UX)

Anatomy of a Modal:
  ┌──────────────────────────────┐
  │ ████████ Backdrop ██████████ │
  │ ██┌────────────────────┐████ │
  │ ██│ Header       [X]  │████ │
  │ ██├────────────────────┤████ │
  │ ██│                    │████ │
  │ ██│  Content / Body    │████ │
  │ ██│                    │████ │
  │ ██├────────────────────┤████ │
  │ ██│  [Cancel] [Confirm]│████ │
  │ ██└────────────────────┘████ │
  │ ████████████████████████████ │
  └──────────────────────────────┘

  Backdrop:   Semi-transparent overlay covering the page
  Header:     Title + close button (X)
  Content:    Main body of the dialog
  Footer:     Action buttons (primary + secondary)

Key Behaviors:
  1. Opens on top of all content (top layer or z-index)
  2. Backdrop prevents clicking behind
  3. Focus trapped inside modal
  4. Escape key closes modal
  5. Focus returns to trigger element on close
  6. Background scroll is disabled
EOF
}

cmd_html() {
    cat << 'EOF'
=== HTML <dialog> Element ===

Native browser element for modal and non-modal dialogs.
Supported in all modern browsers (Chrome 37+, FF 98+, Safari 15.4+).

--- Basic Usage ---
  <dialog id="myDialog">
    <h2>Confirm Action</h2>
    <p>Are you sure you want to delete this item?</p>
    <form method="dialog">
      <button value="cancel">Cancel</button>
      <button value="confirm">Confirm</button>
    </form>
  </dialog>

  <button onclick="myDialog.showModal()">Open Modal</button>

--- JavaScript API ---
  const dialog = document.getElementById('myDialog');

  dialog.showModal();      // Open as MODAL (with backdrop, focus trap)
  dialog.show();           // Open as MODELESS (no backdrop)
  dialog.close('result');  // Close with optional return value

  dialog.open              // boolean: is it open?
  dialog.returnValue       // string: value passed to close()

--- Form Method Dialog ---
  <form method="dialog">
    <button value="cancel">Cancel</button>
    <button value="ok">OK</button>
  </form>

  // When a button is clicked:
  // 1. Form submits (no network request!)
  // 2. Dialog closes automatically
  // 3. dialog.returnValue = button's value attribute

--- Events ---
  dialog.addEventListener('close', () => {
    console.log('Closed with:', dialog.returnValue);
  });

  dialog.addEventListener('cancel', (e) => {
    // Fired when Escape is pressed
    // e.preventDefault() to prevent closing
    console.log('User pressed Escape');
  });

--- Backdrop ---
  dialog::backdrop {
    background: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(4px);
  }

  // ::backdrop is a pseudo-element automatically created
  // Only appears when using showModal() (not show())

--- Click Outside to Close ---
  dialog.addEventListener('click', (e) => {
    const rect = dialog.getBoundingClientRect();
    if (e.clientX < rect.left || e.clientX > rect.right ||
        e.clientY < rect.top || e.clientY > rect.bottom) {
      dialog.close();
    }
  });

--- Top Layer ---
  showModal() places dialog in the browser's "top layer"
  - Above all z-index stacking contexts
  - No CSS z-index hacks needed
  - Cannot be obscured by other elements
  - Multiple top-layer elements stack in order

--- Advantages Over Custom Modals ---
  ✓ Built-in backdrop and top-layer positioning
  ✓ Built-in Escape key handling
  ✓ Built-in focus trapping (basic)
  ✓ Built-in form integration (method="dialog")
  ✓ Accessible by default (role="dialog" implied)
  ✓ No JavaScript library needed for basic modals
  ✓ Inert applied to background automatically
EOF
}

cmd_accessibility() {
    cat << 'EOF'
=== Modal Accessibility ===

--- ARIA Roles and Attributes ---
  <dialog role="dialog" aria-modal="true" aria-labelledby="title">
    <h2 id="title">Confirm Delete</h2>
    <p id="desc">This action cannot be undone.</p>
  </dialog>

  role="dialog"         Dialog role (implied by <dialog>)
  role="alertdialog"    For urgent messages requiring response
  aria-modal="true"     Tells assistive tech it's modal
  aria-labelledby       Points to the dialog title
  aria-describedby      Points to description text
  aria-label            Alternative to labelledby for simple dialogs

  Note: <dialog> with showModal() sets these automatically!

--- Required Accessibility Features ---
  1. Focus moves INTO modal when opened
     → First focusable element or the dialog itself

  2. Focus is TRAPPED inside modal
     → Tab/Shift+Tab cycles within modal only

  3. Escape key closes the modal
     → <dialog> handles this natively

  4. Focus RETURNS to trigger element on close
     → Save reference before opening, restore on close

  5. Background content is inert
     → <dialog> + showModal() handles this
     → For custom modals: use inert attribute on siblings

  6. Screen reader announces modal opening
     → role="dialog" + aria-label/labelledby

--- Screen Reader Behavior ---
  When modal opens:
    NVDA:      "Dialog: [title]"
    VoiceOver: "[title], dialog"
    JAWS:      "Dialog, [title]"

  Content outside modal should be unreachable:
    Cannot navigate to it with screen reader
    Cannot Tab to it
    <dialog> handles this via "inert" mechanism

--- Testing Checklist ---
  [ ] Modal is announced by screen reader
  [ ] Focus moves to modal on open
  [ ] Tab cycles within modal only
  [ ] Shift+Tab cycles backward within modal
  [ ] Escape closes modal
  [ ] Focus returns to trigger on close
  [ ] Background content is not reachable
  [ ] Close button is accessible (has label)
  [ ] Color contrast meets WCAG AA (4.5:1)
  [ ] Modal is usable with keyboard only
  [ ] Works with zoom up to 200%
  [ ] Content is readable by screen reader in order
EOF
}

cmd_focus() {
    cat << 'EOF'
=== Focus Management ===

--- Focus Trapping ---
  Keep Tab/Shift+Tab cycling within the modal.

  function trapFocus(dialog) {
    const focusable = dialog.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );
    const first = focusable[0];
    const last = focusable[focusable.length - 1];

    dialog.addEventListener('keydown', (e) => {
      if (e.key !== 'Tab') return;

      if (e.shiftKey) {
        if (document.activeElement === first) {
          e.preventDefault();
          last.focus();
        }
      } else {
        if (document.activeElement === last) {
          e.preventDefault();
          first.focus();
        }
      }
    });
  }

  Note: <dialog>.showModal() provides basic focus trapping natively.

--- Focus Restoration ---
  let previouslyFocused;

  function openModal(dialog) {
    previouslyFocused = document.activeElement;
    dialog.showModal();
  }

  dialog.addEventListener('close', () => {
    previouslyFocused?.focus();
  });

--- Initial Focus ---
  Default: first focusable element inside the dialog.
  Override with autofocus attribute:

  <dialog>
    <input type="text">
    <button autofocus>Primary Action</button>  <!-- gets focus -->
  </dialog>

  For dangerous actions, focus the SAFE option (Cancel, not Delete).

--- inert Attribute ---
  Make background non-interactive and invisible to assistive tech:

  <main inert>
    <!-- entire page is non-interactive when modal is open -->
  </main>
  <dialog open>...</dialog>

  <dialog>.showModal() applies inert to siblings automatically.
  For custom modals, manually set inert on siblings.

  // When opening:
  document.querySelector('main').inert = true;
  // When closing:
  document.querySelector('main').inert = false;

--- Focusable Elements ---
  These elements are focusable by default:
    <a href="...">         Links with href
    <button>               Buttons
    <input>                Form inputs (not hidden)
    <select>               Dropdowns
    <textarea>             Text areas
    [tabindex="0"]         Custom focusable elements
    [contenteditable]      Editable elements

  NOT focusable:
    <div>, <span>, <p>     (unless tabindex added)
    [tabindex="-1"]        (programmatically focusable only)
    [disabled]             Disabled form elements
    [inert] children       Everything inside inert subtree
EOF
}

cmd_css() {
    cat << 'EOF'
=== Modal CSS ===

--- Basic Dialog Styling ---
  dialog {
    border: none;
    border-radius: 12px;
    padding: 0;
    max-width: 500px;
    width: 90vw;
    box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
  }

  dialog::backdrop {
    background: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(4px);
  }

--- Open/Close Animation ---
  /* Opening animation */
  dialog[open] {
    animation: fadeIn 200ms ease-out;
  }

  dialog[open]::backdrop {
    animation: backdropFadeIn 200ms ease-out;
  }

  @keyframes fadeIn {
    from { opacity: 0; transform: scale(0.95) translateY(-10px); }
    to   { opacity: 1; transform: scale(1) translateY(0); }
  }

  @keyframes backdropFadeIn {
    from { opacity: 0; }
    to   { opacity: 1; }
  }

  /* Closing animation (requires JavaScript) */
  dialog.closing {
    animation: fadeOut 150ms ease-in;
  }

  // JS: animate close before calling dialog.close()
  dialog.classList.add('closing');
  dialog.addEventListener('animationend', () => {
    dialog.classList.remove('closing');
    dialog.close();
  }, { once: true });

--- Scroll Lock ---
  /* Prevent background scrolling when modal is open */
  body:has(dialog[open]) {
    overflow: hidden;
  }

  /* Alternative (JavaScript): */
  function lockScroll() {
    document.body.style.overflow = 'hidden';
    document.body.style.paddingRight =
      window.innerWidth - document.documentElement.clientWidth + 'px';
  }
  function unlockScroll() {
    document.body.style.overflow = '';
    document.body.style.paddingRight = '';
  }

  // paddingRight compensates for scrollbar disappearing

--- Responsive Modal ---
  /* Full screen on mobile, centered on desktop */
  dialog {
    max-width: 500px;
    width: 90vw;
    max-height: 85vh;
    overflow-y: auto;
  }

  @media (max-width: 640px) {
    dialog {
      max-width: 100%;
      width: 100%;
      max-height: 100%;
      height: 100%;
      border-radius: 0;
      margin: 0;
    }
  }

--- Centering ---
  /* <dialog> is centered by default with showModal() */
  /* For custom positioning: */
  dialog {
    margin: auto;           /* centered (default for showModal) */
    position: fixed;        /* for custom modals */
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
  }

--- Sticky Header/Footer ---
  .dialog-body {
    max-height: 60vh;
    overflow-y: auto;
    padding: 1rem;
  }

  .dialog-header,
  .dialog-footer {
    position: sticky;
    background: white;
    padding: 1rem;
  }
  .dialog-header { top: 0; border-bottom: 1px solid #eee; }
  .dialog-footer { bottom: 0; border-top: 1px solid #eee; }
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Modal UI Patterns ===

--- Confirmation Dialog ---
  "Are you sure you want to delete this item?"
  [Cancel] [Delete]

  Rules:
    - Title clearly states the action
    - Body explains consequences
    - Destructive action is visually distinct (red button)
    - Focus starts on Cancel (safe option)
    - Include item name in the message

--- Form Dialog ---
  Modal containing a form for quick data entry.

  Rules:
    - Submit on Enter (if single input)
    - Validate before closing
    - Show errors inline within the modal
    - Don't lose form data on accidental close
    - Consider sheet/drawer for long forms

--- Multi-Step Wizard ---
  Step-by-step process within a modal.

  ┌──────────────────────────────┐
  │ Step 2 of 4: Shipping       │
  │ ■ ■ □ □ (progress indicator)│
  ├──────────────────────────────┤
  │ [Address fields]             │
  ├──────────────────────────────┤
  │ [Back]          [Continue]   │
  └──────────────────────────────┘

  Rules:
    - Show progress (step N of M)
    - Allow going back
    - Validate each step before advancing
    - Consider if a full page would be better (>4 steps)

--- Alert Dialog ---
  Critical information requiring acknowledgment.

  <dialog role="alertdialog" aria-labelledby="alert-title">
    <h2 id="alert-title">Session Expired</h2>
    <p>Your session has expired. Please log in again.</p>
    <button autofocus>OK</button>
  </dialog>

  Use role="alertdialog" for screen reader announcement.

--- Lightbox ---
  Image/media preview in modal overlay.

  Rules:
    - Click backdrop to close
    - Arrow keys for prev/next
    - Preload adjacent images
    - Show counter (3 of 12)
    - Pinch-to-zoom on mobile

--- Bottom Sheet (Mobile) ---
  Modal that slides up from bottom on mobile.
  Touch-friendly. Can be partially visible.
  Swipe down to dismiss.
  Examples: iOS share sheet, Google Maps details

--- Command Palette ---
  Keyboard-triggered modal for quick actions (Cmd+K).
  Searchable command list.
  Examples: VS Code (Cmd+P), Spotlight, Raycast
  Auto-focus on search input.

--- Toast vs Modal Decision ---
  Use toast for:  "Item saved successfully" (non-blocking)
  Use modal for:  "Delete this item?" (requires decision)
  Use banner for: "New version available" (persistent, non-blocking)
EOF
}

cmd_frameworks() {
    cat << 'EOF'
=== Modal Components in Frameworks ===

--- React ---
  // Using React Portal (render outside component tree):
  import { createPortal } from 'react-dom';

  function Modal({ isOpen, onClose, children }) {
    if (!isOpen) return null;

    return createPortal(
      <div className="modal-backdrop" onClick={onClose}>
        <dialog open onClick={e => e.stopPropagation()}>
          <button onClick={onClose} aria-label="Close">×</button>
          {children}
        </dialog>
      </div>,
      document.body
    );
  }

  // Using native <dialog> with ref:
  function NativeModal({ children }) {
    const ref = useRef(null);

    useEffect(() => {
      ref.current?.showModal();
      return () => ref.current?.close();
    }, []);

    return <dialog ref={ref}>{children}</dialog>;
  }

  // Libraries: Radix Dialog, Headless UI, React Aria

--- Vue ---
  <template>
    <Teleport to="body">
      <dialog ref="dialogRef" @close="$emit('close')">
        <slot />
        <button @click="dialogRef.close()">Close</button>
      </dialog>
    </Teleport>
  </template>

  <script setup>
  const dialogRef = ref(null);
  onMounted(() => dialogRef.value?.showModal());
  </script>

--- Angular ---
  // Using CDK Dialog or native <dialog>
  @Component({
    template: `
      <dialog #dialog>
        <ng-content></ng-content>
        <button (click)="close()">Close</button>
      </dialog>
    `
  })
  export class ModalComponent implements AfterViewInit {
    @ViewChild('dialog') dialog!: ElementRef<HTMLDialogElement>;

    ngAfterViewInit() {
      this.dialog.nativeElement.showModal();
    }

    close() {
      this.dialog.nativeElement.close();
    }
  }

--- Recommended Libraries ---
  React:   @radix-ui/react-dialog (unstyled, accessible)
           @headlessui/react (Tailwind-oriented)
           react-aria (Adobe, full accessibility)

  Vue:     @headlessui/vue
           Radix Vue

  Angular: @angular/cdk/dialog
           Angular Material MatDialog

  Vanilla: <dialog> element (no library needed!)

  All modern libraries use native <dialog> under the hood.
EOF
}

cmd_antipatterns() {
    cat << 'EOF'
=== Modal Anti-Patterns ===

1. Modal on Page Load
   Problem: User hasn't interacted yet, immediately blocked
   Examples: Newsletter popups, cookie walls, app rating prompts
   Fix: Delay, use banner instead, or trigger on user action
   Studies: 70% of users find immediate modals annoying

2. Modal Hell (Nested Modals)
   Problem: Opening a modal from within a modal
   User: Lost, confused about navigation context
   Fix: Use a single modal with step navigation
   Or: Close first modal before opening second
   Rule: Maximum 1 modal deep

3. Non-Dismissible Modal
   Problem: No close button, no Escape, no backdrop click
   User: Trapped, forced to take action
   Fix: Always provide Escape and close button
   Exception: Critical errors that genuinely require action

4. Scroll Jank
   Problem: Background scrolls when modal is open
   Or: Scrollbar disappears causing layout shift
   Fix: body { overflow: hidden; padding-right: [scrollbar-width]; }
   Use scrollbar-gutter: stable on html for prevention

5. Breaking Back Button
   Problem: Back button doesn't close modal (navigates away)
   User: Expects modal to close, loses page context
   Fix: Push history state on open, pop on close
   Or: Use a dedicated page instead of a modal

6. Mobile Modals Without Touch Optimization
   Problem: Small close button, no swipe-to-dismiss
   Fix: Large touch targets (44×44px minimum)
   Use bottom sheet pattern on mobile
   Enable swipe-to-dismiss gesture

7. Inaccessible Focus
   Problem: Focus not moved to modal, not trapped, not restored
   Screen reader: User doesn't know modal opened
   Keyboard user: Can tab to hidden content behind modal
   Fix: Use native <dialog> or proper focus management

8. Oversized Content
   Problem: Modal content exceeds viewport, can't scroll
   Fix: max-height: 85vh with overflow-y: auto
   Or: Use a page instead of a modal for large content
   Rule: If content needs scrolling, reconsider using a modal
EOF
}

show_help() {
    cat << EOF
modal v$VERSION — Modal Dialog Reference

Usage: script.sh <command>

Commands:
  intro          Modal vs modeless, when to use, anatomy
  html           HTML <dialog>: showModal, close, forms, top layer
  accessibility  ARIA roles, screen readers, testing checklist
  focus          Focus trapping, restoration, inert, tab order
  css            Styling: backdrop, animations, scroll lock, responsive
  patterns       UI patterns: confirm, form, wizard, lightbox, toast
  frameworks     React, Vue, Angular modal components and libraries
  antipatterns   Modal hell, scroll jank, accessibility failures
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    html)          cmd_html ;;
    accessibility) cmd_accessibility ;;
    focus)         cmd_focus ;;
    css)           cmd_css ;;
    patterns)      cmd_patterns ;;
    frameworks)    cmd_frameworks ;;
    antipatterns)  cmd_antipatterns ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "modal v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
