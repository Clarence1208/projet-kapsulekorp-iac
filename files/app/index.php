<?php
require_once __DIR__ . "/config.php";

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

function db_connect() {
    $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
    $conn->set_charset("utf8mb4");
    return $conn;
}

$connected = false;
$error_msg = "";

try {
    $conn = db_connect();
    $connected = true;
} catch (Exception $e) {
    $error_msg = $e->getMessage();
}

/* -------- CRUD helpers -------- */
function get_items($conn) {
    $res = $conn->query("SELECT id, name, description, created_at FROM items ORDER BY id DESC");
    return $res->fetch_all(MYSQLI_ASSOC);
}
function create_item($conn, $name, $desc) {
    $stmt = $conn->prepare("INSERT INTO items (name, description) VALUES (?, ?)");
    $stmt->bind_param("ss", $name, $desc);
    $stmt->execute();
    $stmt->close();
}
function update_item($conn, $id, $name, $desc) {
    $stmt = $conn->prepare("UPDATE items SET name=?, description=? WHERE id=?");
    $stmt->bind_param("ssi", $name, $desc, $id);
    $stmt->execute();
    $stmt->close();
}
function delete_item($conn, $id) {
    $stmt = $conn->prepare("DELETE FROM items WHERE id=?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $stmt->close();
}

/* -------- Router -------- */
$action = $_POST['action'] ?? $_GET['action'] ?? null;

if ($connected) {
    try {
        if ($action === "create") {
            $name = trim($_POST['name'] ?? "");
            $desc = trim($_POST['description'] ?? "");
            if ($name !== "") create_item($conn, $name, $desc);
            header("Location: /"); exit;
        }
        if ($action === "update") {
            $id = (int)($_POST['id'] ?? 0);
            $name = trim($_POST['name'] ?? "");
            $desc = trim($_POST['description'] ?? "");
            if ($id > 0 && $name !== "") update_item($conn, $id, $name, $desc);
            header("Location: /"); exit;
        }
        if ($action === "delete") {
            $id = (int)($_GET['id'] ?? 0);
            if ($id > 0) delete_item($conn, $id);
            header("Location: /"); exit;
        }
    } catch (Exception $e) {
        $error_msg = $e->getMessage();
    }
}

$edit_id = (int)($_GET['edit'] ?? 0);
$edit_item = null;

$items = [];
if ($connected) {
    $items = get_items($conn);
    if ($edit_id > 0) {
        foreach ($items as $it) {
            if ((int)$it['id'] === $edit_id) $edit_item = $it;
        }
    }
}

$env_name = htmlspecialchars(getenv('ENV_NAME') ?: 'unknown');
?>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <title>KapsuleKorp CRUD</title>
  <style>
    body { font-family: system-ui, sans-serif; margin: 40px; max-width: 900px; }
    .ok { color: green; font-weight: 700; }
    .fail { color: red; font-weight: 700; }
    table { border-collapse: collapse; width: 100%; margin-top: 12px; }
    th, td { border: 1px solid #ddd; padding: 8px; vertical-align: top; }
    th { background: #f6f6f6; text-align: left; }
    input, textarea { width: 100%; padding: 8px; margin-top: 4px; }
    .actions a { margin-right: 10px; }
    .card { padding: 12px; border: 1px solid #ddd; border-radius: 8px; margin: 12px 0; background: #fafafa; }
  </style>
</head>
<body>

<h1>KapsuleKorp - <?= $env_name ?></h1>

<h3>État connexion MySQL</h3>
<?php if ($connected): ?>
  <p class="ok">Connexion DB OK ✅</p>
<?php else: ?>
  <p class="fail">Connexion DB FAIL ❌</p>
  <pre><?= htmlspecialchars($error_msg) ?></pre>
<?php endif; ?>

<?php if ($connected): ?>
  <div class="card">
    <h3><?= $edit_item ? "Modifier un item" : "Créer un item" ?></h3>

    <?php if (!$edit_item): ?>
      <form method="POST">
        <input type="hidden" name="action" value="create">
        <label>Nom</label>
        <input name="name" required>
        <label>Description</label>
        <textarea name="description" rows="3"></textarea>
        <button type="submit">Créer</button>
      </form>
    <?php else: ?>
      <form method="POST">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="<?= (int)$edit_item['id'] ?>">
        <label>Nom</label>
        <input name="name" value="<?= htmlspecialchars($edit_item['name']) ?>" required>
        <label>Description</label>
        <textarea name="description" rows="3"><?= htmlspecialchars($edit_item['description'] ?? "") ?></textarea>
        <button type="submit">Mettre à jour</button>
        <a href="/">Annuler</a>
      </form>
    <?php endif; ?>
  </div>

  <h3>Liste des items</h3>
  <?php if (count($items) === 0): ?>
    <p>Aucun item pour l’instant.</p>
  <?php else: ?>
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Nom</th>
          <th>Description</th>
          <th>Créé le</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
      <?php foreach ($items as $it): ?>
        <tr>
          <td><?= (int)$it['id'] ?></td>
          <td><?= htmlspecialchars($it['name']) ?></td>
          <td><?= nl2br(htmlspecialchars($it['description'] ?? "")) ?></td>
          <td><?= htmlspecialchars($it['created_at']) ?></td>
          <td class="actions">
            <a href="/?edit=<?= (int)$it['id'] ?>">✏️ Edit</a>
            <a href="/?action=delete&id=<?= (int)$it['id'] ?>"
               onclick="return confirm('Supprimer cet item ?')">🗑 Delete</a>
          </td>
        </tr>
      <?php endforeach; ?>
      </tbody>
    </table>
  <?php endif; ?>
<?php endif; ?>

</body>
</html>