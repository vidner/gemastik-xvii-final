class ClauseBuilder:
    def __init__(self) -> None:
        self._queries = []
        self._chars_to_sanitize = ["'", '"']
        self._is_where_called = False

    def _sanitize(self, q) -> str:
        for c in self._chars_to_sanitize:
            if c in q:
                q = q.replace(c, c * 2)
        return str(q).strip()

    def _where(self, column, value, op) -> map:
        if not self._is_where_called:
            op = "WHERE"
            self._is_where_called = True
        return map(self._sanitize, [column, value, op])

    def final(self) -> str:
        q = " ".join(self._queries)
        self.__init__()
        return str(q).strip()

    def order_by(self, column, value) -> None:
        column, value = map(self._sanitize, [column, value])
        self._queries.append("ORDER BY")
        self._queries.append('"' + column + '"')
        self._queries.append(value)

    def select(self, table) -> None:
        table = self._sanitize(table)
        self._queries.append("SELECT")
        self._queries.append("*")
        self._queries.append("FROM")
        self._queries.append('"' + table + '"')

    def where(self, column, value, cmp="ILIKE", op="AND") -> None:
        column, value, op = self._where(column, value, op)
        self._queries.append(op)
        self._queries.append('"' + column + '"')
        if column == "id":
            self._queries.append("=")
            self._queries.append(str(int(value)))
        elif cmp == "EQ":
            self._queries.append("=")
            self._queries.append("'" + value + "'")
        else:
            self._queries.append("ILIKE")
            self._queries.append("'%" + value + "%'")


class QueryBuilder:
    def __init__(self) -> None:
        self._cb = ClauseBuilder()
        self._obj = {}
        self._defined_keys = ["table", "columns"]
        self._sorting_values = ["asc", "desc"]
        self._login_keys = ["username"]

    def _order_by(self) -> None:
        for value, column in self._obj.items():
            if value in self._sorting_values:
                self._cb.order_by(column, value)
                break

    def _select(self) -> None:
        self._cb.select(self._obj["table"])

    def _where(self) -> None:
        for column, value in self._obj.items():
            if column in self._defined_keys + self._sorting_values:
                continue
            elif column in self._login_keys:
                self._cb.where(column, value, "EQ")
            else:
                self._cb.where(column, value)

    def generate(self, obj) -> str:
        self._obj = obj
        self._select()
        self._where()
        self._order_by()
        return self._cb.final()
