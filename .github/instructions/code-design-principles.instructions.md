---
description: 'Foundational software design principles (SOLID, DRY, YAGNI, Law of Demeter, KISS, etc.) for consistent refactoring and code generation.'
applyTo: '**'
---

# Software Design Principles Instructions

These instructions guide the model when reviewing, refactoring, or generating code so outputs embody well-established engineering principles without over-engineering.

Apply pragmatically: clarity, correctness, and evolvability outweigh dogmatic rule enforcement.

## Usage Modes

When the user:

1. Says "refactor" → Identify code smells first, map to principles, then propose minimal safe changes.
2. Says "apply SOLID / DRY / ..." → Explain trade-offs, show deltas not full rewrites unless asked.
3. Asks "is this good?" → Give a structured assessment (Principle → Observation → Impact → Suggested action).
4. Wants new code → Design first (responsibilities + data flow) before emitting implementation.

Always confirm assumptions if critical context (domain rules, performance constraints, concurrency model) is missing.

## Quick Reference Table

| Principle | Essence | Abuse Warning |
|-----------|---------|---------------|
| S (Single Responsibility) | One reason to change | Over-splitting inflates indirection |
| O (Open/Closed) | Extend without modifying | Premature abstractions increase complexity |
| L (Liskov Substitution) | Subtypes honor contracts | Silent contract violations cause subtle bugs |
| I (Interface Segregation) | Small specific interfaces | Too many fragments reduce discoverability |
| D (Dependency Inversion) | Depend on abstractions | Needless indirection for simple cases |
| DRY | Remove knowledge duplication | Shared premature abstractions couple unrelated code |
| YAGNI | Don't build unproven futures | Too literal → blocks necessary foundational design |
| Law of Demeter | Talk only to your immediate friends | Over-wrapping leads to anemic pass-through layers |
| KISS | Keep it simple & clear | Oversimplification hides needed structure |
| SoC (Separation of Concerns) | Isolate distinct responsibilities | Excess layering for trivial logic |
| SLAP (Single Level of Abstraction per function) | Uniform abstraction depth per block | Over-refactoring into micro-functions |

Conflict Resolution Order (default heuristic): Clarity > Correctness > Testability > Extensibility > Performance (unless clearly a hot path).

---

## 1. SOLID Principles Deep Dive

### 1.1 Single Responsibility Principle (SRP)

Essence: A module/class should have exactly one reason to change.

Heuristics:

- Name contains conjunctions (UserAndOrderManager) → split.
- Method groups unrelated domains (billing + logging) → extract.
- Volatile concerns (formatting, persistence, validation) intertwined.

Refactor Steps:

1. List distinct responsibilities.
2. For each, mark stable vs volatile.
3. Extract volatile or orthogonal concerns first.
4. Preserve public API; introduce facades if needed.

Bad Example (mixed concerns):

```python
class ReportService:
    def generate_and_email(self, data, user_email):
        html = self._render_html(data)        # rendering
        pdf = self._to_pdf(html)              # conversion
        self._store(pdf)                      # persistence
        self._email(pdf, user_email)          # notification
```

Improved (orchestrator + dedicated collaborators):

```python
class ReportGenerator: ...
class PdfRenderer: ...
class ReportRepository: ...
class Mailer: ...
class ReportWorkflow:
    def __init__(self, gen, repo, mail):
        self.gen, self.repo, self.mail = gen, repo, mail
    def generate_and_email(self, data, email):
        pdf = self.gen.build_pdf(data)
        self.repo.save(pdf)
        self.mail.send(pdf, email)
```

Avoid: Splitting tiny classes whose changes always co-occur.

### 1.2 Open/Closed Principle (OCP)

Essence: Add new behavior via extension, not core modification. Defer abstraction until a second (or clearly imminent) concrete variant exists to avoid speculative design.

Indicators to apply:

- Frequent switch/if chains on type or enum.
- Repeated copy-paste modifying a minor variant.

Pattern Toolbox: Strategy, Template Method, Polymorphic registration.

Refactor Flow:

1. Identify axis of change (e.g., pricing algorithm).
2. Define abstraction capturing stable protocol.
3. Extract concrete implementations.
4. Introduce factory/registry.

Anti-Pattern: Abstracting before second concrete need.

### 1.3 Liskov Substitution Principle (LSP)

Essence: Subtypes must not strengthen preconditions nor weaken postconditions.

Red Flags:

- Subclass marks a base method as unsupported (throws or signals an unsupported-operation error).
- Overridden method narrows acceptable input range.
- Subclass alters semantic meaning (e.g., `Square : Rectangle` width/height coupling).

Checklist:

- Compare base vs override contracts (inputs, outputs, invariants, side effects).
- Provide failing substitution scenario to illustrate violation.

Fix Strategy: Replace inheritance with composition or clarify contract.

No-Violation Guard (when NOT to refactor):

- If a subclass adds only performance optimizations while preserving externally observable behavior and contracts, treat it as acceptable.
- If all overridden methods keep the same input domain and postconditions, and no client code would need to special-case the subtype, avoid suggesting structural change.
- If inheritance exists solely to share a tiny helper and no divergent behavior is anticipated, prefer leaving it until a concrete variation emerges (YAGNI) or extract a utility instead of forcing an abstraction.

Prefer Composition / Generics Instead of Inheritance When:

1. You only need to reuse 1-2 small behaviors but inherit a large surface (risk: fragile base class).
2. Subclass would toggle features on/off (presence of many no-op overrides indicates interface fragmentation risk).
3. Invariants differ (subclass must constantly guard against base assumptions - indicates semantic mismatch).
4. Behavior variation is orthogonal and could be passed in as a function / strategy / type parameter cleanly.
5. Testing the subclass requires stubbing deep internals of the base (tight coupling symptom).

Quick Mental Substitution Test: "Could I pass the subclass everywhere the base is used without any additional if / type checks?" If yes → likely fine. If no → investigate LSP violation.

### 1.4 Interface Segregation Principle (ISP)

Essence: Many client-specific small interfaces are better than one bloated one.

Signals:

- Clients implement methods returning placeholders (null / no-op).
- Changes for one consumer force recompile of many.

Refactor: Slice interface along usage clusters, then adapt via facades where broad contract is still needed.

### 1.5 Dependency Inversion Principle (DIP)

Essence: High-level policy code should not depend on low-level details directly; both depend on abstractions. Skip introducing interfaces when only one stable implementation exists, variation likelihood is low, and test seams are already achievable.

Approach:

1. Identify direction of business rules → infrastructure leakage.
2. Extract ports (interfaces) for persistence, messaging, external APIs.
3. Implement adapters; wire via composition root / injector.

Pitfall: Introducing interfaces for trivial value objects or pure functions.

Quick LSP / DIP Anti-Pattern Tips:

| Symptom | Smell | Better Action |
|---------|-------|---------------|
| Subclass marks base method unsupported (stub/exception) | LSP violation | Replace inheritance with role interface + composition |
| Subclass narrows parameter type or rejects valid base inputs | LSP precondition strengthening | Redesign contract or extract variant policy object |
| Interface has single implementation created "for testability" only | Over-abstracted DIP | Use concrete type or pure function; introduce port only when variation/testing seam adds value |
| High-level service directly instantiates infrastructure (e.g., new DbClient()) | Hidden dependency | Inject collaborator (constructor) only if it simplifies testing or enables swap |
| Multiple no-op / empty overrides across hierarchy | Inheritance misuse | Collapse hierarchy or apply composition of capabilities |

Heuristic: If an abstraction does not eliminate at least one concrete conditional today AND no second implementation is imminent, defer it (OCP + YAGNI alignment).

---

## 2. DRY (Don't Repeat Yourself)

Scope Clarification: DRY is about duplicated knowledge, not necessarily duplicated text.

Checklist:

- Is duplication accidental or intentional for clarity?
- Will unifying increase cognitive load or coupling?
Explicit Exceptions:
- Intentional duplication for readability or isolated test setup is acceptable.
- Prefer "duplication now, abstraction later" over premature generalization.

Refactor Decision Matrix:

| Duplicate Kind | Action |
|----------------|-------|
| Exact logic with divergent future change risk | Extract shared abstraction |
| Boilerplate enforced by framework | Allow / use code gen |
| Similar but conceptually different | Keep separate (avoid speculative generalization) |

Minimal Refactor Steps: isolate common intent → name it → replace occurrences.

---

## 3. YAGNI (You Aren't Gonna Need It)

Goal: Resist speculative features until a concrete requirement emerges.

Signals of Violation:

- Placeholder classes with no callers.
- Over-parameterized constructors for hypothetical variants.
- Generic abstractions with single implementation.

Guardrails:

- Ask: "What current user story breaks without this?" If none → omit.
- Prefer iteration stubs (TODO markers) over scaffolding full unused layers.

Keep Balanced: Provide extension seams only when cost of later change would be prohibitive (e.g., public API version boundary).

---

## 4. Law of Demeter (LoD)

Definition: "Only talk to your immediate collaborators" - avoid exposing deep object graph structure through chaining purely for data retrieval.

Intent: Reduce coupling to internal structure, keep behavior near the data, simplify testing/mocking.

NOT a ban on method chaining: fluent builders, functional / reactive transformation pipelines (map → filter → reduce), streams (Rx/Reactor, Flow, JS arrays), and immutable value pipelines are fine when each step produces a new value or traverses a stable abstraction boundary.

Two mental buckets:

- Transformation Pipeline (GOOD): verbs over the same value or successive immutable values (e.g., `items.filter(...).map(...).groupBy(...)`).
- Traversal Train Wreck (RISKY): chained dereferences walking internal structure (e.g., `order.getCustomer().getAccount().getBillingProfile().getAddress().getPostalCode()`).

Red Flags (encapsulate or move behavior):

1. Crosses >1 aggregate boundary (Order → Customer → Account ...).
2. Chain exists only to extract primitive data for an external decision ("data hoisting").
3. Mixed responsibilities in one expression (fetch + format + persist).
4. Repeated null/undefined guards (`?.` everywhere) signalling dispersed defensive logic.
5. Breaking an intermediate link would invalidate many tests (fragile traversal contract).

Acceptable / Encouraged Chains (keep):

- Pure functional collection / stream transformations.
- DSL / builder APIs where readability improves (query builders, configuration builders).
- Pipelines returning new immutable values each step (no hidden shared mutable state).
- Internal chaining hidden behind a short facade method exposing one semantic action.

Refactor Decision Heuristic:

- Reads like "fetch inside fetch inside fetch" → move logic behind a method (`order.shippingPostalCode()`).
- Reads like "transform value through verbs" → leave as is.

Refactor Tools: Move Method, Introduce Facade, Tell-Don't-Ask (push decision into the domain object), Aggregate accessor (`order.shippingAddress()`), Domain service encapsulation.

Mini Example:

Bad (data hoisting):

```typescript
const postal = order.getCustomer().getAccount().getBillingProfile().getAddress().getPostalCode();
if (isRemoteArea(postal)) scheduleSpecialCarrier(order);
```

Improved (tell, not ask):

```typescript
if (order.requiresSpecialCarrier(remoteAreaPolicy)) {
  scheduleSpecialCarrier(order);
}
```

Where `order.requiresSpecialCarrier(policy)` internally obtains / caches the postal code.

Checklist:

- Depth > 2 object boundaries? Reconsider.
- External decision on raw data? Move decision inward.
- Pure transformation pipeline? Accept.
- Transformation pipeline with no deep graph exposure is exempt from LoD refactor unless leaking domain internals.

---

## 5. KISS (Keep It Simple & Straightforward)

Assess Simplicity On:

- Control flow clarity
- Cyclomatic complexity
- Number of conceptual models introduced

Technique: Prefer explicitness > cleverness; degrade gracefully to more structure only when real complexity appears.

---

## 6. Separation of Concerns (SoC)

Heuristic Layers: Domain (pure rules), Application (use cases), Interface/Transport (HTTP, CLI), Infrastructure (DB, messaging).

Refactor: Untangle side effects from pure computations so they can be tested independently.

---

## 7. SLAP (Single Level of Abstraction per Function)

Detection: Mixed raw I/O calls, domain rules, and low-level loops in one function.

Refactor Ladder:

1. Inline comments -> function extractions.
2. Group statements by abstraction layer.
3. Each function either orchestrates steps or performs one conceptual step - not both.

---

## 8. Integrated Refactoring Workflow (For Generated Output)

Lean Path (Small / Local Change Scenario): Use this lighter sequence when only one clear smell exists and risk is low.

1. Identify single smell & name principle (e.g., "Long method → SLAP").
2. Propose one concise action ("Extract pricing loop to OrderPricer").
3. Show minimal diff (only affected lines).
4. State risk & verification ("Behavior identical; add unit test for calcTotal").
5. Stop - do NOT introduce new abstractions unless they directly remove duplication or clarify intent now.

Full Path (Broader / Multi-Smell Scenario):

When asked to "improve" code:

1. Inventory: List smells (duplication, long method, feature envy, primitive obsession, shotgun surgery risk, etc.).
2. Map: Associate each smell with a guiding principle (e.g., duplication → DRY, long method with mixed abstraction → SLAP + SRP).
3. Propose Plan: Ordered minimal changes with risk notes.
4. Show Diffs: Only changed lines (contextual) unless full rewrite requested.
5. Validate: State expected behavioral equivalence and new extension points.
6. Caution: Note any trade-offs introduced (extra indirection, additional classes, runtime cost) and justify.

Template Guidance: The following template is guidance; omit non-applicable sections instead of fabricating content.

Output Template:

```text
Assessment:
- Principle: SRP
  Observation: Function handles auth + rendering.
  Impact: Hard to reuse rendering.
  Action: Extract AuthValidator.
Refactor Plan (ordered):
1. Extract AuthValidator
2. Move rendering to TemplateRenderer
3. Inject via constructor
Risk: Low; add unit tests around existing controller first.
```

---

## 9. Principle Interaction & Trade-offs

- DRY vs YAGNI: Do not unify until at least two real usages and shared semantics are stable.
- SRP vs Performance: In hot paths, function inlining might be clearer + faster than granular decomposition.
- DIP vs Simplicity: For small scripts, direct concrete use may be clearer.
- LoD vs Exposure: Adding pass-through methods solely to hide chains may create needless wrappers.

Decision Heuristics Matrix:

| Situation | Principle Emphasis |
|-----------|-------------------|
| Frequent divergent change in one class | SRP split |
| Switch statements proliferating | OCP strategy |
| Duplicate algorithms with subtle differences | DRY cautiously (maybe Template Method) |
| Planned but uncertain feature | YAGNI (document assumption) |
| Chain of 3+ dereferences | LoD (introduce facade/move method) |

---

## 10. Prompting Aids (Internal Use)

When user says: "Apply SOLID" → Ask: Which axis of change hurts today? Provide ranked list; avoid blanket class explosion.

When user says: "Make it DRY" → Verify semantic duplication. If not, warn about false DRY.

When user says: "Generalize" → Challenge with YAGNI unless third concrete example exists.

When user says: "Too many layers" → Evaluate if abstractions deliver isolation value. Propose consolidation.

---

## 11. Minimal Example Synthesis

Initial (violates multiple principles):

```typescript
function process(order: any, db: any, mailer: any) {
  if(!order.items || order.items.length === 0) throw new Error('empty');
  let total = 0; for (const i of order.items) total += i.price * (i.qty || 1);
  db.save({ ...order, total });
  mailer.send(order.customer.email, 'Total=' + total);
  return total;
}
```

Improved (SRP, DIP, SLAP, LoD adherence):

```typescript
interface OrderRepository { save(order: OrderRecord): void }
interface Mailer { send(to: string, body: string): void }
class OrderPricer { calcTotal(items: Item[]): number { /* pure loop */ } }
class OrderProcessor {
  constructor(private repo: OrderRepository, private mailer: Mailer, private pricer: OrderPricer) {}
  process(order: Order): number {
    this.assertNotEmpty(order);
    const total = this.pricer.calcTotal(order.items);
    this.repo.save({ ...order, total });
    this.mailer.send(order.customer.email, `Total=${total}`);
    return total;
  }
  private assertNotEmpty(order: Order) { if(!order.items?.length) throw new Error('empty'); }
}
```

Trade-off Note: Added indirection; justified by need to test pricing separately & swap persistence.

### Premature Abstraction vs Simple Conditional (YAGNI + OCP Guard)

Premature (early Strategy pattern with only one concrete implementation):

```typescript
interface DiscountStrategy { apply(p: number): number }
class SeasonalDiscount implements DiscountStrategy { apply(p: number) { return p * 0.9 } }
// Only one strategy exists; abstraction cost not yet justified
class PriceCalculator {
  constructor(private strategy: DiscountStrategy) {}
  final(price: number) { return this.strategy.apply(price) }
}
```

Simpler (sufficient until second variation appears):

```typescript
function finalPrice(price: number, seasonal: boolean) {
  return seasonal ? price * 0.9 : price;
}
```

Refactor Later When:

- Multiple independent discount axes (e.g., seasonal + loyalty + coupon) generate branching explosion.
- Need runtime registration of discount modules (plugin/feature toggle use cases).
- Cross-cutting concerns (logging, metrics) must wrap interchangeable algorithms cleanly.

Guardrails:

- Do NOT introduce a Strategy just to "future-proof" one branch.
- Prefer simple conditional until a second real variant or composition of policies emerges.

---

## 12. Checklist Before Delivery

- [ ] Principle application solves an actual problem described by user.
- [ ] No speculative abstractions (YAGNI respected).
- [ ] Public API stability preserved unless explicitly allowed to break.
- [ ] Tests (or test guidance) updated / provided for refactors.
- [ ] Complexity reduction > Indirection increase.
- [ ] Rationale & trade-offs clearly communicated.

## 13. Summary

Use principles as decision lenses - never as automatic mandates. Prefer smallest coherent change that improves clarity, correctness, and adaptability. Explicitly communicate trade-offs so humans can judge value.
