/*
 * Package : WiltServerClient
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 12/12/2017
 * Copyright :  S.Hamblett
 */

import 'dart:convert';
import 'package:json_object_lite/json_object_lite.dart';
import 'package:wilt/src/nosql_json_object.dart';
import 'package:wilt/wilt.dart';
import 'package:json_object_lite/json_object_lite.dart' as jsonobject;
import 'package:test/test.dart';
import 'wilt_test_config.dart';

/// Common API test class
class WiltTestCommon {
  /// Test run entry point
  static void run(
      Wilt wilting, Wilt dbTestWilting, String databaseName, Function logger) {
    /* Helper functions */
    void logMessage(String message) {
      logger(message);
    }

    int groupNum = 2;
    /* Basic methods parameter validation  */
    group("${groupNum++}. Basic Methods Parameter Validation - ", () {
      int testNum = 1;
      test("${testNum++}. No Database Set HEAD", () {
        expect(() => wilting.head(null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. No Database Set GET", () {
        expect(() => wilting.get(null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. No Database Set POST", () {
        expect(() => wilting.post(null, "1"), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. No Database Set PUT", () {
        expect(() => wilting.put(null, "1"), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. No Database Set DELETE", () {
        expect(() => wilting.delete(null), throwsA(TypeMatcher<WiltException>()));
      });
    }, skip: false);

    /* Document/Database methods parameter validation  */
    group("${groupNum++}. Document/Database Parameter Validation - ", () {
      int testNum = 1;
      test("${testNum++}. Get Document no id", () {
        expect(() => wilting.getDocument(null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Get Document Revision no id", () {
        expect(() => wilting.getDocumentRevision(null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Delete Document no id", () {
        expect(() => wilting.deleteDocument(null, null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Delete Document no rev", () {        
        expect(() => wilting.deleteDocument('1', null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Put Document no id", () {
        dynamic doc;
        expect(() => wilting.putDocument(null, doc), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Put Document no data", () {
        dynamic doc;
        expect(() => wilting.putDocument('1', null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Post Document no document body", () {
        expect(() => wilting.postDocument(null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Post Document String no document string", () {
        expect(() => wilting.postDocumentString(null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Create Database no name", () {
        expect(() => wilting.createDatabase(null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Delete Database no name", () {
        expect(() => wilting.deleteDatabase(null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. All Docs invalid limit ", () {
        expect(() => wilting.getAllDocs(limit: -1), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Generate Ids invalid amount ", () {
        expect(() => wilting.generateIds(-1), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Copy document no source id", () {
        expect(() => wilting.copyDocument(null, '1'), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Copy document no destinationid", () {
        expect(() => wilting.copyDocument('1', null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Login null user name", () {
        try {
          wilting.login(null, "password");
        } catch (e) {
          expect(e.runtimeType.toString(), 'WiltException');
          expect(e.toString(),
              WiltException.header + WiltException.loginWrongParams);
        }
      });

      test("${testNum++}. Login null password", () {
        try {
          wilting.login("name", null);
        } catch (e) {
          expect(e.runtimeType.toString(), 'WiltException');
          expect(e.toString(),
              WiltException.header + WiltException.loginWrongParams);
        }
      });

      test("${testNum++}. Create Attachment no Doc Id", () {
        final String payload = 'Hello';
        expect(() => wilting
            .createAttachment(null, 'name', 'rev', 'image/png', payload), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Create Attachment no Attachment name", () {
        final String payload = 'Hello';
        expect(() => wilting.createAttachment('id', null, 'rev', 'image/png', payload), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Create Attachment no Revision", () {
        final String payload = 'Hello';
        expect(() => wilting.createAttachment('id', 'name', null, 'image/png', payload), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Create Attachment no Content Type", () {
        final String payload = 'Hello';
        expect(() => wilting.createAttachment('id', 'name', 'rev', null, payload), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Create Attachment no Payload", () {
        expect(() => wilting.createAttachment('id', 'name', 'rev', 'image/png', null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Update Attachment no Doc Id", () {
        final String payload = 'Hello';
        expect(() => wilting
            .updateAttachment(null, 'name', 'rev', 'image/png', payload), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Update Attachment no Attachment name", () {
        final String payload = 'Hello';
        expect(() => wilting.updateAttachment('id', null, 'rev', 'image/png', payload), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Update Attachment no Revision", () {
        final String payload = 'Hello';
        expect(() => wilting.updateAttachment('id', 'name', null, 'image/png', payload), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Update Attachment no Content Type", () {
        final String payload = 'Hello';
        expect(() => wilting.updateAttachment('id', 'name', 'rev', null, payload), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Update Attachment no Payload", () {
        expect(() => wilting.updateAttachment('id', 'name', 'rev', 'image/png', null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Delete Attachment no Doc Id", () {
        expect(() => wilting.deleteAttachment(null, 'name', 'rev'), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Delete Attachment no Attachment name", () {
        expect(() => wilting.deleteAttachment('id', null, 'rev'), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Delete Attachment no Revision", () {
        expect(() => wilting.deleteAttachment('id', 'name', null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Get Attachment no Doc Id", () {
        expect(() => wilting.getAttachment(null, 'name'), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Get Attachment no Attachment name", () {
        expect(() => wilting.getAttachment('id', null), throwsA(TypeMatcher<WiltException>()));
      });

      test("${testNum++}. Start Notifications no Auth Credentials", () {
        try {
          wilting.startChangeNotification(null);
        } catch (e) {
          expect(e.runtimeType.toString(), 'WiltException');
          expect(e.toString(), WiltException.header + WiltException.cnNoAuth);
        }
      });
    }, skip: false);

    /* Single documents and database methods */
    group("${groupNum++}. Single documents and database - ", () {
      int testNum = 0;
      /* Login if we are using authentication */
      if (userName != null) {
        wilting.login(userName, userPassword);
      }

      /*Group setup */
      String docId;
      String docRev;
      final String putId = 'mytestid';
      final String putId2 = 'mytestid2';
      final String putId3 = 'mytestid3';
      final String copyId = 'mycopyid';
      String returnedDocRev;

      test("${testNum++}. Create Database not authorized", () {
        dbTestWilting.login('freddy', 'freddypass');
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.createDatabasee);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            final dynamic errorResponse = res.jsonCouchResponse;
            expect(errorResponse.error, equals('unauthorized'));
            expect(
                errorResponse.reason, equals('Name or password is incorrect.'));
            expect(res.errorCode, equals(401));
          }
        });
        dbTestWilting.createDatabase(databaseName)
          ..then((res) {
            completer(res);
          });
      });
      /* Create a database then delete it */
      test("${testNum++}. Delete Database", () {
        final checkCompleter = expectAsync1((res) {
          expect(res.method, Wilt.deleteDatabasee);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Delete Database check");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
          }
        });

        final completer = expectAsync1((res) {
          expect(res.method, Wilt.createDatabasee);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Create Database Failed");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
          }

          /* Now delete it */
          wilting.deleteDatabase("wiltdeleteme")
            ..then((res) {
              checkCompleter(res);
            });
        });

        wilting.createDatabase("wiltdeleteme")
          ..then((res) {
            completer(res);
          });
      });

      /* Delete the test database now we know delete is OK before we start the tests */
      test("${testNum++}. Delete Test Database", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.deleteDatabasee);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Create Database Failed");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
          }
        });

        wilting.deleteDatabase(databaseName)
          ..then((res) {
            completer(res);
          });
      });

      /* Create the test database */
      test("${testNum++}. Create Test Database", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.createDatabasee);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Create Test Database Failed");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse["ok"], isTrue);
        });

        wilting.createDatabase(databaseName)
          ..then((res) {
            completer(res);
          });
      });

      test("HEAD null URL", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.headd);
          try {
            expect(res.error, isTrue);
          } catch (e) {
            logMessage("WILT::Head null URL");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
          }
        });

        wilting.db = databaseName;
        wilting.head(null)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Create document(POST) and check", () {
        final checkCompleter = expectAsync1((res) {
          expect(res.method, Wilt.getDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Create Document(POST) and check creation");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          /* Check the documents parameters */
          final dynamic successResponse = res.jsonCouchResponse;
          final String returnedDocId =
              WiltUserUtils.getDocumentId(successResponse);
          expect(returnedDocId, docId);
          expect(successResponse.title, equals("Created by a Post Request"));
          expect(successResponse.version, equals(1));
          expect(successResponse.author, equals("Me"));
        });

        final completer = expectAsync1((res) {
          expect(res.method, Wilt.postDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Create Document(POST) and check");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          /* Get the documents id and re-get the document to check correctness */
          final dynamic successResponse = res.jsonCouchResponse;
          docId = successResponse.id;
          expect(docId, isNot(isEmpty));
          /* Now get the document and check it */
          wilting.getDocument(docId)
            ..then((res) {
              checkCompleter(res);
            });
        });

        wilting.db = databaseName;
        final dynamic document = new JsonObjectLite();;
        document.title = "Created by a Post Request";
        document.version = 1;
        document.author = "Me";
        wilting.postDocument(document)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Create document(PUT) and check", () {
        final checkCompleter = expectAsync1((res) {
          expect(res.method, Wilt.getDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Create Document(PUT) and check updated");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          /* Check the documents parameters */
          final dynamic successResponse = res.jsonCouchResponse;
          final String returnedDocId =
              WiltUserUtils.getDocumentId(successResponse);
          expect(returnedDocId, putId);
          returnedDocRev = WiltUserUtils.getDocumentRev(successResponse);
          expect(successResponse.title, equals("Created by a Put Request"));
          expect(successResponse.version, equals(2));
          expect(successResponse.author, equals("Me again"));
        });

        final completer = expectAsync1((res) {
          expect(res.method, Wilt.putDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Test Put Document and check");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          /* Get the documents id and re-get the document to check correctness */
          final dynamic successResponse = res.jsonCouchResponse;
          final String putDocId = successResponse.id;
          expect(putDocId, equals(putId));
          /* Now get the document and check it */
          wilting.getDocument(putId)
            ..then((res) {
              checkCompleter(res);
            });
        });

        wilting.db = databaseName;
        final dynamic document = new JsonObjectLite();
        document.title = "Created by a Put Request";
        document.version = 2;
        document.author = "Me again";
        wilting.putDocument(putId, document)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Update document(PUT) and check", () {
        final checkUpdater = expectAsync1((res) {
          expect(res.method, Wilt.putDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Update document and check updated");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          /* Check the documents parameters */
          final dynamic successResponse = res.jsonCouchResponse;
          final String returnedDocId = successResponse.id;
          expect(returnedDocId, equals(putId));
          final String returnedDocRev = successResponse.rev;
          expect(returnedDocRev, isNot(equals(docRev)));
          docRev = returnedDocRev;
        });

        final checkCompleter = expectAsync1((res) {
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Update document and check created");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          /* Check the documents parameters */
          final dynamic successResponse = res.jsonCouchResponse;
          final returnedDocId = WiltUserUtils.getDocumentId(successResponse);
          expect(returnedDocId, putId);
          final String returnedDocRev =
              WiltUserUtils.getDocumentRev(successResponse);
          docRev = returnedDocRev;
          expect(successResponse.title,
              equals("Created by a Put Request for checking"));
          expect(successResponse.version, equals(3));
          expect(successResponse.author, equals("Me also"));
          /* Now alter the document using putDocument */
          final dynamic document = new JsonObjectLite();
          document.title = "Created by a Put Request for updating ";
          document.version = 4;
          document.author = "Me also and again";
          final String docString =
              WiltUserUtils.addDocumentRev(document, returnedDocRev);
          wilting.putDocumentString(putId, docString)
            ..then((res) {
              checkUpdater(res);
            });
        });

        final completer = expectAsync1((res) {
          expect(res.method, Wilt.putDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Update document and check");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          /* Get the documents id and re-get the document to check correctness */
          final dynamic successResponse = res.jsonCouchResponse;
          final String putDocId = successResponse.id;
          expect(putDocId, equals(putId));
          /* Now get the document and check it */
          wilting.getDocument(putId)
            ..then((res) {
              checkCompleter(res);
            });
        });

        wilting.db = databaseName;
        final dynamic document = new JsonObjectLite();
        document.title = "Created by a Put Request for checking";
        document.version = 3;
        document.author = "Me also";
        document._rev = returnedDocRev;
        wilting.putDocument(putId, document)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Get document revision and check ", () {
        wilting.db = databaseName;
        wilting.getDocumentRevision(putId)
          ..then((rev) {
            if (rev != null) {
              expect(rev == docRev, true);
            }
          });
      });

      test("${testNum++}. Delete document and check ", () {
        final checkCompleter = expectAsync1((res) {
          expect(res.method, Wilt.deleteDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Delete document and check deletion");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          /* Check the document has been deleted */
          final dynamic successResponse = res.jsonCouchResponse;
          final String putDocId = successResponse.id;
          expect(putDocId, equals(putId3));
        });

        final completer = expectAsync1((res) {
          expect(res.method, Wilt.putDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Delete document and check");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          /* Get the documents id and re-get the document to check correctness */
          final dynamic successResponse = res.jsonCouchResponse;
          final String putDocId = successResponse.id;
          expect(putDocId, equals(putId3));
          final String returnedDocRev = successResponse.rev;
          /* Now delete the document and check it */
          wilting.deleteDocument(putId3, returnedDocRev)
            ..then((res) {
              checkCompleter(res);
            });
        });

        wilting.db = databaseName;
        final dynamic document = new JsonObjectLite();
        document.title = "Created by a Put Request for deleting";
        document.version = 1;
        document.author = "Its me again";
        wilting.putDocument(putId3, document)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Delete document preserve and check ", () {
        final checkCompleter = expectAsync1((res) {
          expect(res.method, Wilt.putDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Delete document preserve and check deletion");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          /* Check the document has been deleted */
          final dynamic successResponse = res.jsonCouchResponse;
          final String putDocId = successResponse.id;
          expect(putDocId, equals(putId2));
        });

        final completer = expectAsync1((res) {
          expect(res.method, Wilt.putDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Delete document preserve and check");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          /* Get the documents id and re-get the document to check correctness */
          final dynamic successResponse = res.jsonCouchResponse;
          final String putDocId = successResponse.id;
          expect(putDocId, equals(putId2));
          final String returnedDocRev = successResponse.rev;
          /* Now delete the document and check it */
          wilting.deleteDocument(putId2, returnedDocRev, true)
            ..then((res) {
              checkCompleter(res);
            });
        });

        wilting.db = databaseName;
        final dynamic document = new JsonObjectLite();
        document.title = "Created by a Put Request for preserve deleting";
        document.version = 1;
        document.author = "Its me again";
        wilting.putDocument(putId2, document)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Copy document", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.copyDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Copy document");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          /* Check the copied document */
          final dynamic successResponse = res.jsonCouchResponse;
          final String copyDocId = successResponse.id;
          expect(copyDocId, equals(copyId));
        });

        wilting.db = databaseName;
        wilting.copyDocument(putId, copyId)
          ..then((res) {
            completer(res);
          });
      });

      /* Raw HTTP Request */
      test("${testNum++}. Raw HTTP Request", () async {
        final String url = "/$databaseName/$putId";
        var res = await wilting.httpRequest(url);
        expect(res.error, isFalse);
        
        final dynamic successResponse = res.jsonCouchResponse;
        final String returnedDocId =
        WiltUserUtils.getDocumentId(successResponse);
        expect(returnedDocId, putId);
      });
    }, skip: false);

    /* Bulk documents */
    group("${groupNum++}. Bulk Documents - ", () {
      int testNum = 0;
      test("${testNum++}. User Utils  - Various", () {
        final String id = "myId";
        final String rev = "1-765frd";
        dynamic record = new JsonObjectLite();
        record.name = "Steve";
        record.tag = "MyTag";
        dynamic record2 = record;

        record = WiltUserUtils.addDocumentIdJo(record, id);
        String tmp = record.toString();
        expect(tmp.contains('_id'), true);
        expect(tmp.contains(id), true);

        record = WiltUserUtils.addDocumentRevJo(record, rev);
        tmp = record.toString();
        expect(tmp.contains('_rev'), true);
        expect(tmp.contains(rev), true);

        record2 = WiltUserUtils.addDocumentIdRevJojsonobject(record, id, rev);
        tmp = record.toString();
        expect(tmp.contains('_rev'), true);
        expect(tmp.contains(rev), true);
        expect(tmp.contains('_id'), true);
        expect(tmp.contains(id), true);

        record2.name = "newName";
        record2.tag = "2-uy6543";
        final List<jsonobject.JsonObjectLite> jList = [record, record2];
        final String bulk = WiltUserUtils.createBulkInsertStringJo(jList);
        expect(bulk, isNotNull);
        expect(bulk,
            '{"docs":[ {"name":"Steve","tag":"MyTag","_id":"myId","_rev":"1-765frd"},{"name":"newName","tag":"2-uy6543","_id":"myId","_rev":"1-765frd"}]}');
      });

      /* Login if we are using authentication */
      if (userName != null) {
        wilting.login(userName, userPassword);
      }

      /* Setup */
      final String putId = 'mytestid';
      final String putId2 = 'mytestid2';
      final String copyId = 'mycopyid';

      test("${testNum++}. Get All Docs  - Include docs", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.getAllDocss);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Get All Docs  - Include docs");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          print(successResponse);
          expect(successResponse.total_rows, equals(3));
          expect(successResponse.rows[1].id, equals(copyId));
          expect(successResponse.rows[2].id, equals(putId));
        });
        /* Login if we are using authentication */
        if (userName != null) {
          wilting.login(userName, userPassword);
        }
        wilting.db = databaseName;
        wilting.getAllDocs(includeDocs: true)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Get All Docs  - limit", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.getAllDocss);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Get All Docs  - limit");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse.total_rows, equals(3));
          expect(successResponse.rows[0].id, isNot(equals(putId)));
          expect(successResponse.rows[0].id, isNot(equals(putId2)));
          final int count = successResponse.rows.length;
          expect(count, equals(1));
        });
        /* Login if we are using authentication */
        if (userName != null) {
          wilting.login(userName, userPassword);
        }
        wilting.db = databaseName;
        wilting.getAllDocs(limit: 1)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Get All Docs  - start key", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.getAllDocss);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Get All Docs  - start key");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse.total_rows, equals(3));
          expect(successResponse.rows[0].id, equals(putId));
          final int count = successResponse.rows.length;
          expect(count, equals(1));
        });
        /* Login if we are using authentication */
        if (userName != null) {
          wilting.login(userName, userPassword);
        }
        wilting.db = databaseName;
        wilting.getAllDocs(startKey: putId)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Get All Docs  - end key", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.getAllDocss);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Test Get All Docs  - end key");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse.total_rows, equals(3));
          expect(successResponse.rows[1].id, equals(copyId));
          final int count = successResponse.rows.length;
          expect(count, equals(3));
        });
        /* Login if we are using authentication */
        if (userName != null) {
          wilting.login(userName, userPassword);
        }
        wilting.db = databaseName;
        wilting.getAllDocs(endKey: putId2)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Get All Docs - key list", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.getAllDocss);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Test Get All Docs  - key list");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse.total_rows, equals(3));
          expect(successResponse.rows[0].id, equals(putId));
          expect(successResponse.rows[1].key, equals(putId2));
          final int count = successResponse.rows.length;
          expect(count, equals(2));
        });
        /* Login if we are using authentication */
        if (userName != null) {
          wilting.login(userName, userPassword);
        }
        wilting.db = databaseName;
        final List keyList = new List<String>();
        keyList.add(putId);
        keyList.add(putId2);
        wilting.getAllDocs(keys: keyList)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Get All Docs  - descending", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.getAllDocss);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Get All Docs  - descending");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse.total_rows, equals(3));
          expect(successResponse.rows[1].id, equals(putId));
          expect(successResponse.rows[0].key, equals(putId2));
          final int count = successResponse.rows.length;
          expect(count, equals(2));
        });
        /* Login if we are using authentication */
        if (userName != null) {
          wilting.login(userName, userPassword);
        }
        wilting.db = databaseName;
        final List keyList = new List<String>();
        keyList.add(putId);
        keyList.add(putId2);
        wilting.getAllDocs(keys: keyList, descending: true)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Bulk Insert Auto Keys", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.bulkk);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Bulk Insert Auto Keys");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse[0]["ok"], isTrue);
          expect(successResponse[1]["ok"], isTrue);
          expect(successResponse[2]["ok"], isTrue);
        });
        /* Login if we are using authentication */
        if (userName != null) {
          wilting.login(userName, userPassword);
        }
        wilting.db = databaseName;
        final List docList = new List<jsonobject.JsonObjectLite>();
        final dynamic document1 = new JsonObjectLite();
        document1.title = "Document 1";
        document1.version = 1;
        document1.attribute = "Doc 1 attribute";
        docList.add(document1);
        final dynamic document2 = new JsonObjectLite();
        document2.title = "Document 2";
        document2.version = 2;
        document2.attribute = "Doc 2 attribute";
        docList.add(document2);
        final dynamic document3 = new JsonObjectLite();
        document3.title = "Document 3";
        document3.version = 3;
        document3.attribute = "Doc 3 attribute";
        docList.add(document3);

        wilting.bulk(docList)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Bulk Insert Supplied Keys", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.bulkStringg);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Bulk Insert Supplied Keys");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse[0].id, equals("MyBulkId1"));
          expect(successResponse[1].id, equals("MyBulkId2"));
          expect(successResponse[2].id, equals("MyBulkId3"));
        });

        /* Login if we are using authentication */
        if (userName != null) {
          wilting.login(userName, userPassword);
        }
        wilting.db = databaseName;

        final dynamic document1 = new JsonObjectLite();
        document1.title = "Document 1";
        document1.version = 1;
        document1.attribute = "Doc 1 attribute";
        final String doc1 = WiltUserUtils.addDocumentId(document1, "MyBulkId1");
        final dynamic document2 = new JsonObjectLite();
        document2.title = "Document 2";
        document2.version = 2;
        document2.attribute = "Doc 2 attribute";
        final String doc2 = WiltUserUtils.addDocumentId(document2, "MyBulkId2");
        final dynamic document3 = new JsonObjectLite();
        document3.title = "Document 3";
        document3.version = 3;
        document3.attribute = "Doc 3 attribute";
        final String doc3 = WiltUserUtils.addDocumentId(document3, "MyBulkId3");
        final List docList = new List<String>();
        docList.add(doc1);
        docList.add(doc2);
        docList.add(doc3);
        final String docs = WiltUserUtils.createBulkInsertString(docList);
        wilting.bulkString(docs)
          ..then((res) {
            completer(res);
          });
      });
    }, skip: false);

    /* Information tests */
    group("${groupNum++}. Information/Utilty Tests - ", () {
      int testNum = 0;
      /* Login if we are using authentication */
      if (userName != null) {
        wilting.login(userName, userPassword);
      }

      test("${testNum++}. Get Session Information", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.getSessionn);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Get Session Failed");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse["ok"], isTrue);
        });

        wilting.getSession()
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Get Stats Information", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.getStatss);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Get Stats Failed");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse.couchdb, isNotNull);
        });

        wilting.getStats()
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Get Database Information - default", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.databaseInfo);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Get Database Information - default");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse.db_name, equals(databaseName));
        });

        wilting.db = databaseName;
        wilting.getDatabaseInfo()
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Get Database Information - specified", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.databaseInfo);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Get Database Information - specified");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse.db_name, equals(databaseName));
        });

        wilting.getDatabaseInfo(databaseName)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Get All DB's", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.getAllDbss);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Get All Db's Failed");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse.contains(databaseName), isTrue);
        });

        wilting.getAllDbs()
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Generate Ids", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.generateIdss);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Generate Ids");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse.uuids.length, equals(10));
        });

        wilting.generateIds(10)
          ..then((res) {
            completer(res);
          });
      });
    }, skip: false);

    /* Attachment tests */
    group("${groupNum++}. Attachment Tests - ", () {
      int testNum = 0;
      /* Login if we are using authentication */
      if (userName != null) {
        wilting.login(userName, userPassword);
      }

      /* Globals for the group */
      String testDocRev;
      final String pngImage =
          'iVBORw0KGgoAAAANSUhEUgAAABwAAAASCAMAAAB/2U7WAAAABl' +
              'BMVEUAAAD///+l2Z/dAAAASUlEQVR4XqWQUQoAIAxC2/0vXZDr' +
              'EX4IJTRkb7lobNUStXsB0jIXIAMSsQnWlsV+wULF4Avk9fLq2r' +
              '8a5HSE35Q3eO2XP1A1wQkZSgETvDtKdQAAAABJRU5ErkJggg==';

      final String pngImageUpdate =
          'iVBORw0KGgoAAAANSUhEUgAAABwAAAASCAMAAAB/2U7WAAAABl' +
              'BMVEUAAAD///+l2Z/dAAAASUlEQVR4XqWQUQoAIAxC2/0vXZDr' +
              'EX4IJTRkb7lobNUStXsB0jIXIAMSsQnWlsV+wULF4Avk9fLq2r' +
              '8a5HSE35Q3eO2XP1A1wQkZSgETvDtKdQAAAABJRU5ErkJggg!!';

      test("${testNum++}. Create document(PUT) for attachment tests and check",
          () {
        final checkCompleter = expectAsync1((res) {
          expect(res.method, Wilt.getDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage(
                "WILT::Create Document(PUT) for attachment tests and check updated");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
          }

          /* Check the documents parameters */
          final dynamic successResponse = res.jsonCouchResponse;
          final String returnedDocId =
              WiltUserUtils.getDocumentId(successResponse);
          expect(returnedDocId, 'attachmentTestDoc');
          testDocRev = WiltUserUtils.getDocumentRev(successResponse);
          expect(successResponse.title,
              equals("Created by a Put Request for attachment testing"));
          expect(successResponse.version, equals(1));
          expect(successResponse.author, equals("SJH"));
        });

        final completer = expectAsync1((res) {
          expect(res.method, Wilt.putDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage(
                "WILT::Test Put Document for attachment tests and check");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
          }

          /* Get the documents id and re-get the document to check correctness */
          final dynamic successResponse = res.jsonCouchResponse;
          final String putDocId = successResponse.id;
          expect(putDocId, equals('attachmentTestDoc'));
          /* Now get the document and check it */
          wilting.getDocument('attachmentTestDoc')
            ..then((res) {
              checkCompleter(res);
            });
        });

        wilting.db = databaseName;
        final dynamic document = new JsonObjectLite();
        document.title = "Created by a Put Request for attachment testing";
        document.version = 1;
        document.author = "SJH";
        wilting.putDocument('attachmentTestDoc', document)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Create Attachment", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.createAttachmentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Create Attachment Failed");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse["ok"], isTrue);
          testDocRev = WiltUserUtils.getDocumentRev(successResponse);
        });

        wilting.db = databaseName;
        wilting.createAttachment('attachmentTestDoc', 'attachmentName',
            testDocRev, 'image/png', pngImage)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Get Create Attachment", () {
        final revisionCompleter = expectAsync1((res) {
          expect(res.method, Wilt.getDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Get Create Attachment Get Document Revision");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
          }

          /* Check the documents parameters */
          final dynamic successResponse = res.jsonCouchResponse;
          final String returnedDocId =
              WiltUserUtils.getDocumentId(successResponse);
          expect(returnedDocId, 'attachmentTestDoc');
          testDocRev = WiltUserUtils.getDocumentRev(successResponse);
          expect(successResponse.title,
              equals("Created by a Put Request for attachment testing"));
          expect(successResponse.version, equals(1));
          expect(successResponse.author, equals("SJH"));
          final List attachments =
              WiltUserUtils.getAttachments(successResponse);
          expect(attachments[0]["name"], 'attachmentName');
          expect(attachments[0]["data"]["content_type"], 'image/png; charset=utf-8');
          expect(attachments[0]["data"]["length"], anything);
          final List bytes =
              new Base64Decoder().convert(attachments[0]["data"]["data"]);
          expect(bytes, pngImage.codeUnits);
        });

        final completer = expectAsync1((res) {
          expect(res.method, Wilt.getAttachmentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Get Create Attachment Failed");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse["ok"], isTrue);
          final String payload = res.responseText;
          expect(payload, equals(pngImage));
          final String contentType = successResponse.contentType;
          expect(contentType, equals('image/png; charset=utf-8'));
          /* Now get the document to get the new revision along
         * with its attachment data
         */
          wilting.getDocument('attachmentTestDoc', null, true)
            ..then((res) {
              revisionCompleter(res);
            });
        });

        wilting.db = databaseName;
        wilting.getAttachment('attachmentTestDoc', 'attachmentName')
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Update Attachment", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.updateAttachmentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Update Attachment Failed");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse["ok"], isTrue);
        });

        wilting.db = databaseName;
        wilting.updateAttachment('attachmentTestDoc', 'attachmentName',
            testDocRev, 'image/png', pngImageUpdate)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Get Update Attachment", () {
        final revisionCompleter = expectAsync1((res) {
          expect(res.method, Wilt.getDocumentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Get Update Attachment Get Document Revision");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
          }

          /* Check the documents parameters */
          final dynamic successResponse = res.jsonCouchResponse;
          final String returnedDocId =
              WiltUserUtils.getDocumentId(successResponse);
          expect(returnedDocId, 'attachmentTestDoc');
          testDocRev = WiltUserUtils.getDocumentRev(successResponse);
          expect(successResponse.title,
              equals("Created by a Put Request for attachment testing"));
          expect(successResponse.version, equals(1));
          expect(successResponse.author, equals("SJH"));
        });

        final completer = expectAsync1((res) {
          expect(res.method, Wilt.getAttachmentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Get Update Attachment Failed");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse["ok"], isTrue);
          testDocRev = WiltUserUtils.getDocumentRev(successResponse);
          final String payload = res.responseText;
          expect(payload, equals(pngImageUpdate));
          final String contentType = successResponse.contentType;
          expect(contentType, equals('image/png; charset=utf-8'));
          /* Now get the document to get the new revision  */
          wilting.getDocument('attachmentTestDoc')
            ..then((res) {
              revisionCompleter(res);
            });
        });

        wilting.db = databaseName;
        wilting.getAttachment('attachmentTestDoc', 'attachmentName')
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Create Attachment With New Document", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.createAttachmentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Create Attachment Failed");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse["ok"], isTrue);
        });

        wilting.db = databaseName;
        wilting.createAttachment('anotherAttachmentTestDoc', 'attachmentName',
            '', 'image/png', pngImage)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Create Attachment Invalid Revision", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.createAttachmentt);
          expect(res.error, isTrue);
          final int statusCode = res.errorCode;
          expect(statusCode, anyOf(0, 409));
        });

        wilting.db = databaseName;
        wilting.createAttachment('attachmentTestDoc', 'anotherAttachmentName',
            '1-bb48c078f0fac47234e774a7a51b86ac', 'image/png', pngImage)
          ..then((res) {
            completer(res);
          });
      });

      test("${testNum++}. Delete Attachment", () {
        final completer = expectAsync1((res) {
          expect(res.method, Wilt.deleteAttachmentt);
          try {
            expect(res.error, isFalse);
          } catch (e) {
            logMessage("WILT::Delete Attachment Failed");
            final dynamic errorResponse = res.jsonCouchResponse;
            final String errorText = errorResponse.error;
            logMessage("WILT::Error is $errorText");
            final String reasonText = errorResponse.reason;
            logMessage("WILT::Reason is $reasonText");
            final int statusCode = res.errorCode;
            logMessage("WILT::Status code is $statusCode");
            return;
          }

          final dynamic successResponse = res.jsonCouchResponse;
          expect(successResponse["ok"], isTrue);
        });

        wilting.db = databaseName;
        wilting.deleteAttachment(
            'attachmentTestDoc', 'attachmentName', testDocRev)
          ..then((res) {
            completer(res);
          });
      });
    }, skip: false);

    /* Change Notifications */
    group("${groupNum++}. Change Notification Tests - ", () {
      int testNum = 0;
      /* Login for change notification */
      if (userName != null) {
        wilting.login(userName, userPassword);
      }

      test("${testNum++}. Start Change Notification", () {
        wilting.db = databaseName;
        void wrapper() {
          wilting.startChangeNotification();
        }

        expect(wrapper, returnsNormally);
      });

      test("${testNum++}. Check Change Notifications", () {
        final completer = expectAsync0(() {
          wilting.stopChangeNotification();
        });

        wilting.changeNotification.listen((e) {
          if (e.docId == 'mytestid2')
            expect(
                (e.type == WiltChangeNotificationEvent.updatee) ||
                    (e.type == WiltChangeNotificationEvent.deletee),
                true);
          if (e.docId == 'mytestid3')
            expect(e.type, WiltChangeNotificationEvent.deletee);
          if (e.docId == 'anotherAttachmentTestDoc') completer();
        });
      });

      test("${testNum++}. Start Change Notification With Docs and Attachments",
          () {
        wilting.db = databaseName;
        final WiltChangeNotificationParameters parameters =
            new WiltChangeNotificationParameters();
        parameters.includeDocs = true;
        parameters.includeAttachments = true;
        void wrapper() {
          wilting.startChangeNotification(parameters);
        }

        expect(wrapper, returnsNormally);
      });

      test("${testNum++}. Check Change Notifications With Docs", () {
        final completer = expectAsync0(() {});

        wilting.changeNotification.listen((e) {
          if (e.docId == 'mytestid2') {
            if (e.type == WiltChangeNotificationEvent.updatee) {
              final dynamic document = e.document;
              expect(document.title, "Created by a Put Request for updating ");
              expect(document.version, 4);
              expect(document.author, "Me also and again");
            } else {
              expect(e.type == WiltChangeNotificationEvent.deletee, true);
            }
          }
          if (e.docId == 'mytestid3')
            expect(e.type, WiltChangeNotificationEvent.deletee);
          if (e.docId == 'anotherAttachmentTestDoc') {
            final List attachments = WiltUserUtils.getAttachments(e.document);
            expect(attachments[0]["name"], 'attachmentName');
            expect(
                attachments[0]["data"]["content_type"], "image/png; charset=utf-8");
            completer();
          }
        });
      });

      test("${testNum++}. Notification Pause", () {
        int count = 0;

        final completer = expectAsync0(() {
          expect(count, 3);
          wilting.pauseChangeNotifications();
        });

        wilting.changeNotification.listen((e) {
          count++;
          expect(e.type, WiltChangeNotificationEvent.lastSequence);
          if (count == 3) completer();
        });
      });

      test("${testNum++}. Check Notification Pause", () {
        final completer = expectAsync0(() {
          expect(wilting.changeNotificationsPaused, true);
        });

        completer();
      });

      test("${testNum++}. Notification Restart", () {
        int count = 0;

        final completer = expectAsync0(() {
          expect(wilting.changeNotificationsPaused, false);
          expect(count, 3);
          wilting.stopChangeNotification();
        });

        wilting.restartChangeNotifications();
        wilting.changeNotification.listen((e) {
          count++;
          expect(e.type, WiltChangeNotificationEvent.lastSequence);
          if (count == 3) completer();
        });
      });
    }, skip: false);
  }
}
