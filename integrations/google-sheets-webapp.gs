// google-sheets-webapp.gs
function doPost(e) {
  try {
    const body = JSON.parse(e.postData.contents);
    const ss = SpreadsheetApp.getActiveSpreadsheet();
    const sh = ss.getSheetByName("Cmdr Logs") || ss.insertSheet("Cmdr Logs");
    if (sh.getLastRow() === 0) {
      sh.appendRow(["Timestamp","AuditID","Command","Executor","Level","Args","Result","PlaceID","JobID"]);
    }
    const argsPretty = body.args ? JSON.stringify(body.args) : "";
    sh.appendRow([
      new Date(),
      body.id || "",
      body.command || "",
      body.executor || "",
      body.permissionLevel || "",
      argsPretty,
      body.resultText || "",
      body.placeId || "",
      body.jobId || ""
    ]);
    return ContentService.createTextOutput(JSON.stringify({ ok: true })).setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ ok:false, error: String(err) })).setMimeType(ContentService.MimeType.JSON);
  }
}