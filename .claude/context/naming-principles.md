# Naming Convention Principles

**Last Updated**: 2025-10-28
**Status**: ✅ ENFORCED

---

## Core Principle: Idiomatic Naming

**Use the naming convention native to each layer of the stack:**

- **Frontend (React/TypeScript)**: `camelCase` for all variables, properties, functions
- **Backend (NestJS/TypeScript)**: `camelCase` for all TypeScript code
- **Database (PostgreSQL)**: `snake_case` for all columns and tables
- **API Contract**: `camelCase` (frontend and backend communicate in camelCase)

---

## Implementation Rules

### 1. Backend Entities (TypeORM)

**ALWAYS use `@Column({ name: 'snake_case' })` for entity properties:**

```typescript
// ✅ CORRECT
@Entity('customers')
export class Customer extends Base {
  @Column({ name: 'tax_number', type: 'varchar', length: 20 })
  taxNumber: string;

  @Column({ name: 'is_active', type: 'boolean', default: false })
  isActive: boolean;

  @Column({ name: 'balance_start', type: 'numeric', precision: 20, scale: 4 })
  balanceStart: number;
}
```

```typescript
// ❌ WRONG - Missing column name mapping
@Column({ type: 'varchar', length: 20 })
taxNumber: string;

@Column({ type: 'boolean', default: false })
isActive: boolean;
```

**Why**: TypeORM automatically converts between JavaScript camelCase and database snake_case when you provide explicit column names.

---

### 2. Database Schema

**ALWAYS use snake_case for column names:**

```sql
-- ✅ CORRECT
CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  tax_number VARCHAR(20),
  is_active BOOLEAN DEFAULT false,
  balance_start NUMERIC(20, 4) DEFAULT 0
);
```

```sql
-- ❌ WRONG - camelCase in database
CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  taxNumber VARCHAR(20),        -- Don't do this!
  isActive BOOLEAN DEFAULT false -- SQL convention is snake_case
);
```

---

### 3. Frontend Types (shared-types)

**ALWAYS use camelCase for type definitions:**

```typescript
// ✅ CORRECT - packages/shared-types/src/entities/customer.types.ts
export interface Customer extends BaseEntity {
  title: string;
  idNo: string;
  taxAdministration: string;
  taxNumber: string;
  bankName: string;
  isActive: boolean;
  balanceStart: number;
}
```

```typescript
// ❌ WRONG - snake_case in TypeScript
export interface Customer {
  tax_number: string; // Don't do this!
  is_active: boolean; // JavaScript convention is camelCase
}
```

---

### 4. API Client (Frontend)

**NO transformation layers needed:**

```typescript
// ✅ CORRECT - Direct pass-through
apiClient.interceptors.response.use((response) => {
  // Backend sends camelCase via TypeORM - no transformation needed
  return response;
});
```

```typescript
// ❌ WRONG - Adding unnecessary transformation
function toCamelCase(obj) {
  /* ... */
} // Don't add this!
return { ...response, data: toCamelCase(response.data) }; // Redundant!
```

---

### 5. QueryBuilder Usage (Backend)

**ALWAYS use QueryBuilderService instead of raw SQL:**

```typescript
// ✅ CORRECT - Type-safe with automatic conversion
async records(requestParams: any) {
  return await this.queryBuilderService.buildQuery(Customer, {
    recordsPerPage: requestParams.recordsPerPage,
    currentPage: requestParams.currentPage,
    where: requestParams.where,
    order: requestParams.order
  });
}
```

```typescript
// ❌ WRONG - Raw SQL requires manual column name handling
async records(requestParams: any) {
  const sql = `SELECT * FROM customers WHERE "is_active" = true`;
  return await this.dataSource.query(sql);
}
```

---

## Migration History

### October 2025 - Naming Convention Standardization

**What Changed**:

1. All 35+ backend entities updated with `@Column({ name: 'snake_case' })` mappings
2. Created `QueryBuilderService` for type-safe query building
3. Refactored 13 services to use QueryBuilder instead of raw SQL
4. Removed frontend `toCamelCase` transformation layer (now redundant)
5. Created global `CommonModule` for shared services

**Documentation**: See `docs/NAMING_CONVENTION_MIGRATION.md` for full details

---

## Quick Reference

| Layer             | Convention | Example                                             |
| ----------------- | ---------- | --------------------------------------------------- |
| TypeScript Code   | camelCase  | `taxNumber`, `isActive`, `balanceStart`             |
| Database Columns  | snake_case | `tax_number`, `is_active`, `balance_start`          |
| Entity Properties | camelCase  | `@Column({ name: 'tax_number' }) taxNumber: string` |
| API Requests      | camelCase  | `{ taxNumber: "123", isActive: true }`              |
| API Responses     | camelCase  | `{ taxNumber: "123", isActive: true }`              |

---

## Common Patterns

### Adding a New Field

```typescript
// 1. Add to database migration
ALTER TABLE customers ADD COLUMN new_field VARCHAR(100);

// 2. Add to backend entity with mapping
@Column({ name: 'new_field', type: 'varchar', length: 100 })
newField: string;

// 3. Add to frontend shared type
export interface Customer {
  newField: string;  // camelCase
}

// 4. Use in frontend
const customer = { newField: 'value' };
await apiClient.post('/customer', customer);
```

### Filtering by Field

```typescript
// Frontend sends camelCase
const filters = [{ fields: ['isActive'], condition: '=', type: 'boolean', keyword: true }];

// Backend QueryBuilder handles conversion automatically
const result = await queryBuilderService.buildQuery(Customer, { where: filters });

// Generated SQL uses snake_case
// WHERE "is_active" = $1
```

---

## Rationale

**Why This Approach**:

1. ✅ **Idiomatic**: Each layer uses its natural convention
2. ✅ **Type-Safe**: TypeORM provides compile-time checking
3. ✅ **Automatic**: No manual transformation needed
4. ✅ **Maintainable**: Single source of truth in entity decorators
5. ✅ **Secure**: QueryBuilder uses parameterized queries

**Why Not Alternatives**:

- ❌ snake_case everywhere: Violates JavaScript/TypeScript conventions
- ❌ Manual transformation: Error-prone and requires extra code
- ❌ Raw SQL: Loses type safety and requires manual column mapping

---

## Enforcement

**Before committing code, verify**:

1. All new entity properties have `@Column({ name: 'snake_case' })` decorators
2. No raw SQL queries (use QueryBuilderService)
3. No transformation functions in API client
4. Frontend types use camelCase
5. Database migrations use snake_case

---

**Remember**: The goal is zero transformation layers. TypeORM handles everything automatically when you follow these principles.
