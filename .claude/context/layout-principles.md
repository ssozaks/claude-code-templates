Mobile-Optimized Form Layout Principles

1. Page Structure

<div className="flex h-full flex-col">
<PageHeader />
<div className="flex-1 overflow-y-auto pb-32 md:pb-0">
    <Form>
    <form>
        <div className="container max-w-4xl py-4 pr-6 pl-6 sm:px-6 sm:py-6 md:px-6">
        {/* form content */}
        </div>
    </form>
    </Form>
</div>
<div className="bg-background fixed right-0 bottom-0 left-0 z-50 border-t shadow-lg md:sticky md:shadow-none">
    {/* footer buttons */}
</div>
</div>

2. Fixed Footer Pattern

- Mobile: fixed right-0 bottom-0 left-0 z-50 border-t shadow-lg
- Desktop: md:sticky md:shadow-none
- Always visible at bottom on mobile, sticky at page end on desktop

3. Scrollable Content Area

- Container: flex-1 overflow-y-auto pb-32 md:pb-0
- Bottom padding pb-32 (128px) on mobile prevents footer overlap
- Reset to pb-0 on desktop where footer is sticky

4. Footer Button Layout

- Container: flex items-center gap-2 px-4 py-3 md:justify-end md:px-6 md:py-4
- Mobile buttons: flex-1 (50-50 split, equal width)
- Desktop buttons: md:flex-initial (auto width)

5. Form Content Padding

- Container: container max-w-4xl py-4 pr-6 pl-6 sm:px-6 sm:py-6 md:px-6
- Consistent 24px horizontal padding on mobile
- Prevents horizontal overflow

6. Manual Form Submission

- Footer is outside <form> element
- Submit button requires: onClick={form.handleSubmit(onSubmit)}
- Type attribute: type="submit" (even though it's outside form)

7. Header Overflow Prevention

- Breadcrumbs container: min-w-0 flex-1
- Page titles: truncate
- User menu wrapper: flex-shrink-0

8. Wide Content Handling (e.g., Permission Tree)

<div className="-mx-6 overflow-x-auto px-6 lg:mx-0 lg:px-0">
<div className="inline-block min-w-full align-top">
    <WideComponent />
</div>
</div>

9. Standard Button Titles and Interaction

Button Titles:

- List Pages: Use "New" for create action buttons (e.g., "New Customer", "New Invoice")
- Form Pages Footer: Use "Save" for submit button and "Cancel" for close/back button
- Consistency: Always use these standard titles across all pages

Interaction States:

- All clickable items must have cursor-pointer class or CSS cursor: pointer
- Applies to: buttons, links, table rows, cards, menu items, icons with actions
- Example: <Button className="cursor-pointer">Save</Button>

Data Table Actions Column:

- The actions column (last column) must NOT have a header label
- Set header to empty string: `header: ''`
- This prevents showing "Actions" or "İşlemler" text in the header
- **Action buttons must be right-aligned** using `justify-end` class
- Example:
  ```tsx
  {
    id: 'actions',
    header: '', // Empty header for actions column
    cell: (row) => (
      <div className="flex items-center justify-end gap-2">
        {/* action buttons */}
      </div>
    ),
  }
  ```

Filter Combobox Widths:

- All filter comboboxes in list pages MUST have equal widths
- Standard width: w-full md:w-[150px]
- Mobile: Full width (w-full)
- Desktop: Fixed 150px width (md:w-[150px])
- Ensures text fits completely without truncation
- Creates consistent visual alignment across filter row
- Example:
  ```tsx
  <SelectTrigger className="w-full md:w-[150px]">
    <SelectValue placeholder="Filter Label" />
  </SelectTrigger>
  ```

10. Icon Container Pattern

Standard Icon Container:

- Container: h-10 w-10 shrink-0 items-center justify-center rounded-lg
- Icon Size: h-4 w-4 (consistent across all icon containers)
- Color Inheritance: Icons should NOT have explicit color classes (e.g., text-white)
- Color Control: Parent container sets text color, icon inherits it

Color Pattern Requirements:

- ALL color classes (background, text, gradients, dark mode) MUST be in the dynamic part
- NEVER hardcode color classes in the JSX className string
- Both solid and gradient backgrounds are acceptable design choices
- Icons inherit color from parent - never add color classes to icons

Example with Light Solid Background (Status-based):

```tsx
const item = {
  icon: <IconName className="h-4 w-4" />,
  status: 'success',
};

<div
  className={`flex h-10 w-10 shrink-0 items-center justify-center rounded-lg ${
    item.status === 'success'
      ? 'bg-green-100 text-green-600 dark:bg-green-900/20'
      : 'bg-yellow-100 text-yellow-600 dark:bg-yellow-900/20'
  }`}
>
  {item.icon}
</div>;
```

Example with Gradient Background (Action-based):

```tsx
const action = {
  icon: <IconName className="h-4 w-4" />,
  color: 'bg-gradient-to-br from-blue-500 to-blue-600 text-white',
};

<div className={`flex h-10 w-10 shrink-0 items-center justify-center rounded-lg ${action.color}`}>
  {action.icon}
</div>;
```

Benefits:

- Consistent icon sizing throughout the application
- Simplified color management (one place to control)
- Better maintainability and theme compatibility
- Icons automatically adapt to container color
- Flexible design - can use solid or gradient backgrounds
- All color logic in data layer, not presentation layer

Key Benefits:

- ✅ Footer always visible on mobile
- ✅ No horizontal scrolling
- ✅ Proper spacing prevents content overlap
- ✅ Consistent button sizes across viewports
- ✅ Works seamlessly on mobile and desktop
- ✅ User avatar always visible in header

11. Advanced Query Builder Pattern for List Pages

Required Components:

```tsx
import { QueryBuilder } from '@/features/reports/components/QueryBuilder';
import { getFieldsForDataSource } from '@/features/reports/utils/query-builder-fields';
import { SlidersHorizontal, Search } from 'lucide-react';
```

State Management:

```tsx
// Add to component state
const [queryBuilderOpen, setQueryBuilderOpen] = useState(false);
const [query, setQuery] = useState<RuleGroupType | null>(null);

// Query change handler
const handleQueryChange = useCallback((newQuery: RuleGroupType) => {
  setQuery(newQuery);
  // Trigger data refetch with new query
}, []);

// Clear filters handler must reset query builder too
const handleClearFilters = () => {
  setFilters({}); // Clear simple filters
  setQuery(null); // Clear query builder
  setQueryBuilderOpen(false); // Close query builder
};
```

Page Structure for List Pages:

```tsx
<div className="flex h-full flex-col">
  <PageHeader title="Entity Name" description="..." />

  {/* Mobile Card View (< md) */}
  <div className="flex-1 overflow-auto px-4 md:hidden">
    {/* CRITICAL: Filters and Query Builder MUST be inside scrollable container */}
    <div className="flex flex-col gap-4 pt-4 pb-4">
      <div className="flex flex-col gap-4">
        {/* Search with Query Builder Toggle */}
        <div className="relative flex-1">
          <Input
            placeholder={t('entity:list.filters.search_placeholder')}
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleSearch()}
            className="pr-20"
          />
          {/* Query Builder Toggle Button */}
          <Button
            type="button"
            variant="ghost"
            size="sm"
            onClick={() => setQueryBuilderOpen(!queryBuilderOpen)}
            title={t('entity:list.filters.toggle_query_builder')}
            className={`absolute top-0 right-10 h-full px-3 py-2 hover:bg-transparent ${queryBuilderOpen ? 'text-primary' : ''}`}
          >
            <SlidersHorizontal className="size-4" />
          </Button>
          <Button
            type="button"
            variant="ghost"
            size="sm"
            onClick={handleSearch}
            className="absolute top-0 right-0 h-full px-3 py-2 hover:bg-transparent"
          >
            <Search className="size-4" />
          </Button>
        </div>

        {/* Other filters (status, currency, etc.) */}
        <Select>...</Select>

        {/* Clear Filters Button */}
        {(filters.search || filters.is_active !== undefined || query) && (
          <Button variant="outline" onClick={handleClearFilters} className="w-full">
            {t('common:table.clear_filter')}
          </Button>
        )}
      </div>

      {/* Query Builder Pane */}
      {queryBuilderOpen && (
        <div className="animate-in slide-in-from-top-2">
          <QueryBuilder
            fields={getFieldsForDataSource('entityType', t)}
            onQueryChange={handleQueryChange}
            initialQuery={query || undefined}
          />
        </div>
      )}
    </div>

    {/* Mobile cards */}
    {isLoading ? <LoadingSpinner /> : <CardList />}
  </div>

  {/* Desktop Table View (>= md) */}
  <div className="hidden flex-1 overflow-auto px-4 md:block md:px-6">
    {/* CRITICAL: Filters and Query Builder MUST be inside scrollable container */}
    <div className="flex flex-col gap-4 py-4">
      <div className="flex flex-col gap-4 md:flex-row">
        {/* Search with Query Builder Toggle - Same structure as mobile */}
        <div className="relative flex-1">
          <Input
            placeholder={t('entity:list.filters.search_placeholder')}
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleSearch()}
            className="pr-20"
          />
          <Button
            type="button"
            variant="ghost"
            size="sm"
            onClick={() => setQueryBuilderOpen(!queryBuilderOpen)}
            title={t('entity:list.filters.toggle_query_builder')}
            className={`absolute top-0 right-10 h-full px-3 py-2 hover:bg-transparent ${queryBuilderOpen ? 'text-primary' : ''}`}
          >
            <SlidersHorizontal className="size-4" />
          </Button>
          <Button
            type="button"
            variant="ghost"
            size="sm"
            onClick={handleSearch}
            className="absolute top-0 right-0 h-full px-3 py-2 hover:bg-transparent"
          >
            <Search className="size-4" />
          </Button>
        </div>

        {/* Other filters with fixed widths */}
        <Select>
          <SelectTrigger className="w-full md:w-[150px]">...</SelectTrigger>
        </Select>

        {/* Clear Filters Button */}
        {(filters.search || filters.is_active !== undefined || query) && (
          <Button variant="outline" onClick={handleClearFilters} className="w-full md:w-auto">
            {t('common:table.clear_filter')}
          </Button>
        )}
      </div>

      {/* Query Builder Pane */}
      {queryBuilderOpen && (
        <div className="animate-in slide-in-from-top-2">
          <QueryBuilder
            fields={getFieldsForDataSource('entityType', t)}
            onQueryChange={handleQueryChange}
            initialQuery={query || undefined}
          />
        </div>
      )}
    </div>

    <DataTable columns={columns} data={data?.records || []} />
  </div>
</div>
```

Critical Requirements:

1. **Scrolling Behavior**:
   - Query builder MUST be inside the scrollable container (`.flex-1.overflow-auto`)
   - It should scroll WITH the data table, not separately
   - Both mobile and desktop versions must follow this pattern

2. **Toggle Button**:
   - Always positioned at `right-10` inside search input
   - Search button at `right-0` (never changes)
   - Active state: `text-primary` class when `queryBuilderOpen === true`
   - Icon: `SlidersHorizontal` from lucide-react

3. **Query Builder Component**:
   - Wrapped in `animate-in slide-in-from-top-2` for smooth animation
   - Receives `fields` from `getFieldsForDataSource(entityType, t)`
   - Translation function `t` MUST be passed to field getter
   - `onQueryChange` callback updates state and triggers data refetch
   - `initialQuery` prop for persisting query state

4. **Clear Filters**:
   - Condition must include `|| query` to show when query builder has rules
   - Handler must call `setQuery(null)` and `setQueryBuilderOpen(false)`
   - Resets both simple filters and query builder state

5. **Field Configuration**:
   - Create entity-specific field definitions in `src/features/reports/utils/query-builder-fields.ts`
   - Follow the pattern: `export const get[Entity]Fields = (t: TFunction): QueryBuilderField[]`
   - Include all searchable/filterable fields from the entity
   - Use proper field types: 'string', 'number', 'date', 'boolean', 'select'
   - For select fields, add `valueEditorType: 'select'` and provide `values` array

6. **Translation Keys**:
   - Add to `src/locales/{lang}/entity.json`:
     ```json
     "list": {
       "filters": {
         "toggle_query_builder": "Advanced Query Builder",
         "search_placeholder": "Search by field..."
       }
     }
     ```
   - Entity-specific field translations in `src/locales/{lang}/reports.json`

Implementation Checklist:

- [ ] State management: `queryBuilderOpen`, `query`, `handleQueryChange`
- [ ] Import QueryBuilder component and field getter function
- [ ] Add toggle button inside search input at `right-10`
- [ ] Place query builder inside scrollable container (mobile AND desktop)
- [ ] Configure clear filters to reset query builder
- [ ] Create entity-specific field definitions
- [ ] Add translation keys for toggle button and fields
- [ ] Test scrolling: query builder and table scroll together
- [ ] Test dark mode: all selects and inputs respect theme
- [ ] Test mobile: query builder works on small screens

12. Pagination Pattern for List Pages

Component Location:

```tsx
import { EnhancedPagination } from '@/components/shared/Pagination/EnhancedPagination';
```

Placement Requirements:

**Desktop (>= md):**

- Pagination must be placed at the BOTTOM of the data table container
- Use sticky positioning: `sticky bottom-0 z-10 bg-background border-t`
- Always visible at the bottom when scrolling the table
- Layout: Page info (left) → Rows selector + Navigation controls (right)

**Mobile (< md):**

- Pagination must be placed at the BOTTOM of the card list container
- Same sticky positioning as desktop
- Layout: Rows selector (left) → Navigation controls (right)
- Maximum 4 page buttons (first 3 pages + ellipsis if more exist)

Component Structure:

```tsx
<div className="flex h-full flex-col">
  <PageHeader title="Entity Name" description="..." />

  {/* Mobile Card View (< md) */}
  <div className="flex-1 overflow-auto px-4 md:hidden">
    {/* Filters */}
    <div className="flex flex-col gap-4 pt-4 pb-4">{/* Filter controls */}</div>

    {/* Cards */}
    {isLoading ? (
      <LoadingSpinner />
    ) : data && data.records.length > 0 ? (
      <div className="space-y-4 pb-4">
        {data.records.map((item) => (
          <Card key={item.id}>...</Card>
        ))}
      </div>
    ) : (
      <EmptyState />
    )}

    {/* Mobile Pagination - Sticky Footer */}
    {data && data.records.length > 0 && (
      <div className="bg-background sticky bottom-0 z-10 border-t">
        <EnhancedPagination
          currentPage={page}
          totalPages={Math.ceil((data?.totalRecords || 0) / perPage)}
          totalRecords={data?.totalRecords || 0}
          recordsPerPage={perPage}
          onPageChange={setPage}
          onRecordsPerPageChange={(newPerPage) => {
            setPerPage(newPerPage);
            setPage(1);
          }}
        />
      </div>
    )}
  </div>

  {/* Desktop Table View (>= md) */}
  <div className="hidden flex-1 overflow-auto px-4 md:block md:px-6">
    {/* Filters */}
    <div className="flex flex-col gap-4 py-4">{/* Filter controls */}</div>

    <DataTable columns={columns} data={data?.records || []} />

    {/* Desktop Pagination - Sticky Footer */}
    {data && data.records.length > 0 && (
      <div className="bg-background sticky bottom-0 z-10 border-t">
        <EnhancedPagination
          currentPage={page}
          totalPages={Math.ceil((data?.totalRecords || 0) / perPage)}
          totalRecords={data?.totalRecords || 0}
          recordsPerPage={perPage}
          onPageChange={setPage}
          onRecordsPerPageChange={(newPerPage) => {
            setPerPage(newPerPage);
            setPage(1);
          }}
        />
      </div>
    )}
  </div>
</div>
```

EnhancedPagination Features:

**Desktop View:**

- Page information: "Showing X to Y of Z records" (left side)
- Rows per page selector: "Rows per page: [dropdown]" (right side)
- Navigation controls: First, Previous, Page Numbers, Next, Last (right side)
- Full pagination with smart ellipsis (siblingCount={1})
- All controls in one horizontal row

**Mobile View:**

- Rows per page selector (left side, no label)
- Navigation controls (right side): First, Previous, Page Numbers, Next, Last
- Compact page numbers (max 4 buttons: first 3 pages + ellipsis)
- All controls in one horizontal row
- No page information text (saves space)

State Management:

```tsx
// Required state
const [page, setPage] = useState(1);
const [perPage, setPerPage] = useState(25);

// When perPage changes, reset to page 1
const handlePerPageChange = (newPerPage: number) => {
  setPerPage(newPerPage);
  setPage(1);
};
```

Conditional Rendering:

```tsx
// Only show pagination when:
// 1. Data exists (not loading)
// 2. Records array has items
{data && data.records.length > 0 && (
  <div className="bg-background sticky bottom-0 z-10 border-t">
    <EnhancedPagination ... />
  </div>
)}
```

Styling Requirements:

- Container: `sticky bottom-0 z-10 bg-background border-t`
- `sticky`: Stays visible at bottom when scrolling
- `bottom-0`: Positioned at the bottom
- `z-10`: Above table content
- `bg-background`: Prevents content showing through
- `border-t`: Top border for visual separation

Page Size Options:

```tsx
// Default options (can be customized)
pageSizeOptions={[10, 25, 50, 100]}
```

Critical Requirements:

1. **Sticky Positioning**: Both mobile and desktop pagination MUST use sticky bottom positioning
2. **Conditional Rendering**: Only show when data exists and has records
3. **Reset Page on Per-Page Change**: Always reset to page 1 when changing rows per page
4. **Consistent Layout**: Use EnhancedPagination component for all list pages
5. **Mobile Optimization**: Maximum 4 page buttons on mobile to prevent overflow
6. **Z-Index**: Must be z-10 to stay above scrolling content

Benefits:

- ✅ Always visible pagination controls
- ✅ No need to scroll to bottom to change page
- ✅ Consistent pagination experience across all list pages
- ✅ Mobile-optimized with compact controls
- ✅ Desktop-optimized with full information display
- ✅ Smooth scrolling with sticky positioning
