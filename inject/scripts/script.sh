#!/usr/bin/env bash
# inject — Dependency Injection Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Dependency Injection ===

Dependency Injection (DI) is a design pattern where objects receive
their dependencies from external sources rather than creating them
internally. It's the practical implementation of the Dependency
Inversion Principle (the "D" in SOLID).

Without DI (tightly coupled):
  class OrderService {
    constructor() {
      this.db = new PostgresDatabase();     // hard-coded
      this.mailer = new SendGridMailer();    // hard-coded
    }
  }
  // Can't test without real DB and mailer!
  // Can't swap implementations!

With DI (loosely coupled):
  class OrderService {
    constructor(db, mailer) {               // injected
      this.db = db;
      this.mailer = mailer;
    }
  }
  // Test: new OrderService(mockDb, mockMailer)
  // Prod: new OrderService(realDb, realMailer)

Why DI Matters:
  ✓ Testability — swap real deps with mocks/fakes
  ✓ Flexibility — change implementations without changing consumers
  ✓ Separation of concerns — each class does one thing
  ✓ Explicit dependencies — clear what a class needs
  ✓ Configuration — different setups per environment

SOLID Connection:
  S — Single Responsibility: DI separates creation from use
  O — Open/Closed: extend by injecting new implementations
  L — Liskov Substitution: inject any compatible implementation
  I — Interface Segregation: depend on narrow interfaces
  D — Dependency Inversion: depend on abstractions, not concretions

Inversion of Control (IoC):
  "Don't call us, we'll call you" (Hollywood Principle)
  Traditional: Component creates its dependencies
  IoC: Framework/container creates and provides dependencies
  DI is ONE implementation of IoC (others: service locator, events)

Key Terms:
  Dependency:   Object that another object needs to function
  Injection:    Providing a dependency to a dependent object
  Container:    Object that manages dependency creation and lifetime
  Registration: Telling the container how to create a service
  Resolution:   Container creating and assembling the object graph
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== DI Patterns ===

--- Constructor Injection (Preferred) ---
  Dependencies provided through constructor parameters

  class UserService {
    constructor(
      private readonly userRepo: UserRepository,
      private readonly hasher: PasswordHasher,
      private readonly logger: Logger
    ) {}

    async createUser(email: string, password: string) {
      const hash = await this.hasher.hash(password);
      const user = await this.userRepo.save({ email, hash });
      this.logger.info(`User created: ${email}`);
      return user;
    }
  }

  Advantages:
    ✓ Dependencies are explicit (visible in constructor)
    ✓ Object is fully initialized after construction
    ✓ Immutable — dependencies can be readonly
    ✓ Easy to spot too many dependencies (refactor signal)
    ✓ TypeScript/Java: enforced at compile time

  Rule of thumb: if constructor has > 4 parameters,
  the class may be doing too much (SRP violation)

--- Property/Setter Injection ---
  Dependencies set via properties after construction

  class ReportGenerator {
    formatter?: ReportFormatter;
    sender?: ReportSender;

    setFormatter(f: ReportFormatter) { this.formatter = f; }
    setSender(s: ReportSender) { this.sender = s; }
  }

  When to use:
    Optional dependencies
    Framework requires default constructor
    Circular dependencies (last resort)

  Disadvantage: object may be in invalid state (deps not set)

--- Method Injection ---
  Dependencies provided per-method call

  class Processor {
    process(data: Data, validator: Validator): Result {
      if (validator.validate(data)) {
        return this.transform(data);
      }
    }
  }

  When to use:
    Dependency varies per operation
    Dependency is operation-specific, not class-wide
    Strategy pattern implementations

--- Interface Injection ---
  Interface defines injection method

  interface LoggerAware {
    setLogger(logger: Logger): void;
  }

  class Service implements LoggerAware {
    private logger!: Logger;
    setLogger(logger: Logger) { this.logger = logger; }
  }

  Rarely used — constructor injection is simpler and safer

--- Factory Pattern with DI ---
  Inject factories when you need to create instances on demand

  class OrderService {
    constructor(
      private readonly orderFactory: (items: Item[]) => Order
    ) {}

    createOrder(items: Item[]): Order {
      return this.orderFactory(items);
    }
  }

  Container can register factory functions alongside services
EOF
}

cmd_containers() {
    cat << 'EOF'
=== IoC Containers ===

Containers automate dependency creation, lifetime management, and wiring.

--- .NET (Microsoft.Extensions.DependencyInjection) ---
  var builder = WebApplication.CreateBuilder(args);

  // Registration
  builder.Services.AddScoped<IUserRepository, UserRepository>();
  builder.Services.AddTransient<IPasswordHasher, BcryptHasher>();
  builder.Services.AddSingleton<ICacheService, RedisCacheService>();

  // Resolution (automatic via constructor injection)
  class UserController {
    public UserController(IUserRepository repo) { ... }
  }

--- Spring (Java) ---
  @Service
  public class UserService {
    private final UserRepository repo;

    @Autowired  // optional in recent Spring (single constructor)
    public UserService(UserRepository repo) {
      this.repo = repo;
    }
  }

  // Configuration class
  @Configuration
  public class AppConfig {
    @Bean
    public PasswordEncoder passwordEncoder() {
      return new BCryptPasswordEncoder();
    }
  }

--- InversifyJS (TypeScript) ---
  @injectable()
  class UserService {
    constructor(
      @inject(TYPES.UserRepo) private repo: IUserRepository,
      @inject(TYPES.Hasher) private hasher: IPasswordHasher
    ) {}
  }

  const container = new Container();
  container.bind<IUserRepository>(TYPES.UserRepo).to(PostgresUserRepo);
  container.bind<IPasswordHasher>(TYPES.Hasher).to(BcryptHasher);

  const service = container.get<UserService>(UserService);

--- tsyringe (TypeScript, lightweight) ---
  @injectable()
  class UserService {
    constructor(
      @inject("UserRepo") private repo: IUserRepository
    ) {}
  }

  container.register("UserRepo", { useClass: PostgresUserRepo });
  const service = container.resolve(UserService);

--- Python (dependency-injector) ---
  from dependency_injector import containers, providers

  class Container(containers.DeclarativeContainer):
      config = providers.Configuration()
      db = providers.Singleton(Database, url=config.db_url)
      user_repo = providers.Factory(UserRepository, db=db)
      user_service = providers.Factory(UserService, repo=user_repo)

--- Go (wire) ---
  // Google Wire: compile-time DI
  func InitializeApp() (*App, error) {
    wire.Build(NewDB, NewUserRepo, NewUserService, NewApp)
    return nil, nil
  }
  // Wire generates the actual initialization code at build time
EOF
}

cmd_lifetimes() {
    cat << 'EOF'
=== Service Lifetimes ===

How long a service instance lives and when a new one is created.

--- Transient ---
  New instance created EVERY time it's requested
  Shortest lifetime

  When to use:
    Lightweight, stateless services
    Services with per-operation state
    Not thread-safety concerns (each gets its own)

  Example: FormValidator, RequestParser, TemporaryFileManager

  ⚠ Don't use for: expensive-to-create services, DB connections

--- Scoped ---
  One instance per SCOPE (typically per HTTP request)
  Same instance shared within a request, new for next request

  When to use:
    Database contexts (DbContext in EF Core)
    Unit of Work pattern
    Per-request caching
    Services that track request-level state

  Example: DbContext, UnitOfWork, CurrentUserService

  ⚠ Don't inject scoped into singleton (captive dependency!)

--- Singleton ---
  ONE instance for entire application lifetime
  Created once, shared everywhere

  When to use:
    Stateless services
    Configuration objects
    Connection pools
    Caches
    Logging services

  Example: CacheService, ConfigService, Logger, HttpClientFactory

  ⚠ Must be thread-safe!
  ⚠ Don't hold state that varies per request

--- Lifetime Hierarchy ---
  Singleton → Scoped → Transient

  RULE: A service can only depend on services with EQUAL OR LONGER lifetime

  ✓ Transient → Singleton (OK: transient can use singleton)
  ✓ Transient → Scoped (OK)
  ✓ Scoped → Singleton (OK)
  ✗ Singleton → Scoped (BAD: captive dependency!)
  ✗ Singleton → Transient (RISKY: transient becomes de-facto singleton)

--- Captive Dependency Problem ---
  class SingletonCache {
    constructor(scopedDbContext) { ... }
    // scopedDbContext is now held FOREVER
    // Never disposed, stale data, connection leak!
  }

  Fix: inject a factory instead
    constructor(dbContextFactory: () => DbContext) { ... }

--- Disposal ---
  Containers typically dispose services when scope ends:
    Transient: disposed when scope ends (not immediately!)
    Scoped: disposed at end of scope (end of request)
    Singleton: disposed at application shutdown

  Implement IDisposable/IAsyncDisposable for cleanup
EOF
}

cmd_testing() {
    cat << 'EOF'
=== DI for Testability ===

DI's biggest practical benefit: making code testable.

--- Test Doubles ---
  Dummy:   Passed but never used (satisfies parameter)
  Stub:    Returns predetermined data (no logic)
  Fake:    Working implementation but simplified (in-memory DB)
  Mock:    Verifies interactions (was method called? with what?)
  Spy:     Wraps real object, records calls

--- Mocking with Injection ---

  // Production code
  class OrderService {
    constructor(
      private repo: OrderRepository,
      private payment: PaymentGateway,
      private notifier: Notifier
    ) {}

    async placeOrder(order: Order): Promise<string> {
      const id = await this.repo.save(order);
      await this.payment.charge(order.total);
      await this.notifier.send(order.customer, 'Order confirmed');
      return id;
    }
  }

  // Test
  test('placeOrder saves and charges', async () => {
    const mockRepo = { save: jest.fn().mockResolvedValue('ord-123') };
    const mockPayment = { charge: jest.fn().mockResolvedValue(true) };
    const mockNotifier = { send: jest.fn().mockResolvedValue(true) };

    const service = new OrderService(mockRepo, mockPayment, mockNotifier);
    const id = await service.placeOrder(testOrder);

    expect(id).toBe('ord-123');
    expect(mockPayment.charge).toHaveBeenCalledWith(testOrder.total);
    expect(mockNotifier.send).toHaveBeenCalledWith(
      testOrder.customer, 'Order confirmed'
    );
  });

--- Fakes for Integration Tests ---
  class InMemoryUserRepository implements UserRepository {
    private users: Map<string, User> = new Map();

    async save(user: User): Promise<string> {
      const id = crypto.randomUUID();
      this.users.set(id, { ...user, id });
      return id;
    }

    async findById(id: string): Promise<User | null> {
      return this.users.get(id) ?? null;
    }
  }

  // Use in tests without touching real database

--- Test Container Setup ---
  // Override specific registrations for testing
  const testContainer = new Container();
  testContainer.bind(TYPES.UserRepo).to(InMemoryUserRepo);
  testContainer.bind(TYPES.Mailer).to(NoOpMailer);
  testContainer.bind(TYPES.Cache).to(InMemoryCache);
  // Real service under test
  testContainer.bind(UserService).toSelf();

--- Without DI (Untestable) ---
  class UserService {
    async createUser(email: string) {
      const db = new PostgresDB();        // can't mock!
      const mailer = new SendGrid();       // can't mock!
      // ...
    }
  }
  // Test requires real Postgres and SendGrid — slow, flaky, costly
EOF
}

cmd_antipatterns() {
    cat << 'EOF'
=== DI Anti-Patterns ===

--- Service Locator ---
  class UserService {
    doWork() {
      const repo = ServiceLocator.get<UserRepository>(); // BAD
      const mailer = ServiceLocator.get<Mailer>();        // BAD
    }
  }

  Why it's bad:
    - Dependencies are hidden (not in constructor)
    - Hard to test (must set up global locator)
    - Runtime errors instead of compile-time errors
    - Violates Dependency Inversion Principle
  Fix: Use constructor injection instead

--- Captive Dependency ---
  A shorter-lived service captured by a longer-lived one

  Singleton → Scoped service → LEAKED!

  The scoped service never gets disposed
  Database connections held forever
  Stale data served from cached scope
  Fix: Inject factory or IServiceScopeFactory

--- Constructor Over-Injection ---
  class GodService {
    constructor(a, b, c, d, e, f, g, h, i, j) { ... }
  }

  Signal: class does too much (SRP violation)
  Fix: Refactor into smaller, focused services
  Rule: > 4 constructor params → time to split

--- Abstract Factory Explosion ---
  Creating a factory for EVERY service
  IFoo, IFooFactory, FooFactory, Foo → 4 types per concept
  Fix: Only use factories when you need deferred/parameterized creation

--- Injecting the Container ---
  class Service {
    constructor(private container: Container) { ... }
    // Container as service locator — hides dependencies
  }

  Fix: Inject specific dependencies, not the container

--- Ambient Context ---
  class Service {
    doWork() {
      const user = CurrentUser.Instance;  // static global
    }
  }

  Hidden dependency, hard to test, shared mutable state
  Fix: Inject current user context

--- Bastard Injection ---
  class Service {
    constructor(repo = new DefaultRepository()) { ... }
  }

  Default creates tight coupling to DefaultRepository
  Tests might accidentally use the real implementation
  Fix: No defaults — make all dependencies explicit

--- Control Freak ---
  class Service {
    private repo = new SpecificRepository();
    // Not injectable at all — tight coupling
  }

  The most basic anti-pattern — no injection point exists
  Fix: Accept dependency via constructor
EOF
}

cmd_typescript() {
    cat << 'EOF'
=== DI in TypeScript / JavaScript ===

--- Manual Wiring (No Container) ---
  // Composition root — one place that wires everything
  function createApp(): App {
    const config = loadConfig();
    const db = new PostgresDatabase(config.dbUrl);
    const userRepo = new UserRepository(db);
    const hasher = new BcryptHasher(10);
    const mailer = new SendGridMailer(config.sendgridKey);
    const userService = new UserService(userRepo, hasher, mailer);
    const userController = new UserController(userService);
    return new App(userController);
  }

  Pros: No magic, no decorators, type-safe, tree-shakeable
  Cons: Manual wiring, no automatic resolution

--- Token-Based (Symbol tokens) ---
  const TOKENS = {
    UserRepo: Symbol('UserRepo'),
    Hasher: Symbol('Hasher'),
    Mailer: Symbol('Mailer'),
  };

  // Register
  container.bind(TOKENS.UserRepo, () => new UserRepository(db));

  // Resolve
  const repo = container.get<UserRepository>(TOKENS.UserRepo);

--- Decorator-Based (reflect-metadata) ---
  // Requires: experimentalDecorators + emitDecoratorMetadata

  @injectable()
  class UserService {
    constructor(
      @inject('UserRepo') private repo: UserRepository,
      @inject('Hasher') private hasher: PasswordHasher
    ) {}
  }

  Libraries: InversifyJS, tsyringe, typedi

--- Functional DI ---
  // Closures as injection mechanism
  function createUserService(repo: UserRepository, hasher: PasswordHasher) {
    return {
      async createUser(email: string, password: string) {
        const hash = await hasher.hash(password);
        return repo.save({ email, hash });
      }
    };
  }

  // Wire up
  const userService = createUserService(repo, hasher);

  Pros: No classes needed, pure functions, simple
  Cons: No container features (lifetime management)

--- Reader Monad Pattern (FP) ---
  type Reader<Deps, A> = (deps: Deps) => A;

  type Deps = {
    userRepo: UserRepository;
    hasher: PasswordHasher;
  };

  const createUser = (email: string): Reader<Deps, Promise<User>> =>
    async ({ userRepo, hasher }) => {
      const hash = await hasher.hash(password);
      return userRepo.save({ email, hash });
    };

  // Run with dependencies
  const user = await createUser('a@b.com')({ userRepo, hasher });

--- Recommendation ---
  Small projects: Manual wiring or functional DI
  Medium projects: tsyringe or manual composition root
  Large projects: InversifyJS with full container
  Framework: Use framework's built-in DI (NestJS, Angular)
EOF
}

cmd_frameworks() {
    cat << 'EOF'
=== Framework-Specific DI ===

--- NestJS ---
  @Injectable()
  export class UserService {
    constructor(
      @InjectRepository(User) private repo: Repository<User>,
      private readonly mailer: MailerService,
    ) {}
  }

  @Module({
    imports: [TypeOrmModule.forFeature([User])],
    providers: [UserService, MailerService],
    controllers: [UserController],
    exports: [UserService],
  })
  export class UserModule {}

  Custom provider:
    providers: [
      { provide: 'CACHE', useClass: RedisCacheService },
      { provide: 'CONFIG', useValue: { ttl: 3600 } },
      { provide: 'FACTORY', useFactory: (config) => new Svc(config),
        inject: ['CONFIG'] },
    ]

--- Angular ---
  @Injectable({ providedIn: 'root' })  // singleton
  export class UserService {
    constructor(private http: HttpClient) {}
  }

  // Module-level provision
  @NgModule({
    providers: [
      { provide: API_URL, useValue: 'https://api.example.com' },
      { provide: UserRepository, useClass: HttpUserRepository },
    ]
  })

--- Spring Boot (Java) ---
  @Service
  public class UserService {
    private final UserRepository repo;

    public UserService(UserRepository repo) {
      this.repo = repo;
    }
  }

  // Profiles for environment-specific beans
  @Profile("test")
  @Bean
  public UserRepository userRepo() {
    return new InMemoryUserRepository();
  }

--- ASP.NET Core ---
  builder.Services.AddScoped<IUserService, UserService>();
  builder.Services.AddDbContext<AppDbContext>(opt =>
    opt.UseNpgsql(connectionString));

  // Controller injection
  [ApiController]
  public class UserController : ControllerBase {
    public UserController(IUserService userService) { ... }
  }

  // Configuration
  builder.Services.Configure<MailSettings>(
    builder.Configuration.GetSection("Mail"));

--- Django (Python) ---
  # Django doesn't have built-in DI container
  # Common approaches:
  # 1. Settings-based configuration
  # 2. django-injector package
  # 3. Manual wiring in apps.py

  # django-injector
  class UserModule(Module):
    def configure(self, binder):
      binder.bind(UserRepository, to=DjangoUserRepository)
      binder.bind(Mailer, to=SendGridMailer)
EOF
}

show_help() {
    cat << EOF
inject v$VERSION — Dependency Injection Reference

Usage: script.sh <command>

Commands:
  intro          DI overview and SOLID connection
  patterns       Constructor, property, method injection
  containers     IoC containers: Spring, .NET, InversifyJS
  lifetimes      Singleton, scoped, transient lifetimes
  testing        DI for testability: mocks, fakes, doubles
  antipatterns   Service locator, captive deps, over-injection
  typescript     DI in TypeScript/JavaScript
  frameworks     NestJS, Angular, Spring Boot, ASP.NET DI
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    patterns)     cmd_patterns ;;
    containers)   cmd_containers ;;
    lifetimes)    cmd_lifetimes ;;
    testing)      cmd_testing ;;
    antipatterns) cmd_antipatterns ;;
    typescript|ts) cmd_typescript ;;
    frameworks)   cmd_frameworks ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "inject v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
