<?lua
  -- TODO redo doc with luadoc rules
  --
  -- @var login: string|null
  --
  -- TODO html special chars!
?>

<form method="post">
    <!-- <label for="login"><b>Username</b></label> -->
    <input type="text" placeholder="Username/Email" name="login" value="<?= login ?>" required />

    <!-- <label for="psw"><b>Password</b></label> -->
    <input type="password" placeholder="Password" name="password" required />

    <button type="submit" name="submit">Login</button>
</form>