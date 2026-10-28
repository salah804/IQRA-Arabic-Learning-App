<?php
require_once __DIR__ . '/cors.php';
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

header('Content-Type: application/json; charset=UTF-8');

require_once 'db_connect.php';

// Quiz 3
$quiz_id = 3;

try {

    // =========================================================
    // GET QUIZ
    // =========================================================

    $quizQuery = "
        SELECT
            Quiz_ID,
            `Text`,
            `Number`
        FROM quiz
        WHERE Quiz_ID = ?
    ";

    $stmt = $conn->prepare($quizQuery);

    if (!$stmt) {
        throw new Exception(
            'Failed to prepare quiz query.'
        );
    }

    $stmt->bind_param(
        'i',
        $quiz_id
    );

    $stmt->execute();

    $quizResult =
        $stmt->get_result();


    if ($quizResult->num_rows === 0) {

        echo json_encode([
            'success' => false,
            'error' => 'Quiz not found'
        ]);

        exit();

    }


    $quiz =
        $quizResult->fetch_assoc();


    $quiz['Quiz_ID'] =
        (int)$quiz['Quiz_ID'];


    if (isset($quiz['Number'])) {

        $quiz['Number'] =
            (int)$quiz['Number'];

    }


    // =========================================================
    // GET QUESTIONS
    // =========================================================

    $questionsQuery = "
        SELECT
            Question_ID,
            `Text`,
            Attachment,
            Score,
            Sound,
            Type
        FROM question
        WHERE Quiz_ID = ?
    ";


    $questionStmt =
        $conn->prepare(
            $questionsQuery
        );


    if (!$questionStmt) {

        throw new Exception(
            'Failed to prepare questions query.'
        );

    }


    $questionStmt->bind_param(
        'i',
        $quiz_id
    );


    $questionStmt->execute();


    $questionsResult =
        $questionStmt->get_result();


    $questions = [];


    // =========================================================
    // LOOP QUESTIONS
    // =========================================================

    while (
        $question =
            $questionsResult->fetch_assoc()
    ) {

        $question['Question_ID'] =
            (int)$question['Question_ID'];


        if ($question['Score'] !== null) {

            $question['Score'] =
                (int)$question['Score'];

        }


        // =====================================================
        // SOUND
        // =====================================================

        if (
            isset($question['Sound']) &&
            $question['Sound'] !== null &&
            $question['Sound'] !== ''
        ) {

            $question['Sound'] =
                base64_encode(
                    $question['Sound']
                );

        } else {

            $question['Sound'] = '';

        }


        // =====================================================
        // GET OPTIONS
        // =====================================================

        $optionsQuery = "
            SELECT
                Option_ID,
                OptionText,
                Answer_flag,
                Is_Clicked
            FROM options
            WHERE Question_ID = ?
        ";


        $optionStmt =
            $conn->prepare(
                $optionsQuery
            );


        if (!$optionStmt) {

            throw new Exception(
                'Failed to prepare options query.'
            );

        }


        $optionStmt->bind_param(
            'i',
            $question['Question_ID']
        );


        $optionStmt->execute();


        $optionsResult =
            $optionStmt->get_result();


        $options = [];


        while (
            $option =
                $optionsResult->fetch_assoc()
        ) {

            $option['Option_ID'] =
                (int)$option['Option_ID'];

            $option['Answer_flag'] =
                (int)$option['Answer_flag'];

            $option['Is_Clicked'] =
                (int)$option['Is_Clicked'];


            $options[] =
                $option;

        }


        $optionStmt->close();


        $question['options'] =
            $options;


        $questions[] =
            $question;

    }


    // =========================================================
    // FINAL JSON
    // =========================================================

    $quiz['questions'] =
        $questions;


    echo json_encode(
        [
            'success' => true,
            'quiz' => $quiz
        ],
        JSON_UNESCAPED_UNICODE
    );


    $questionStmt->close();
    $stmt->close();


} catch (Throwable $e) {
    error_log('fetch_quiz3.php error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Unable to load quiz. Please try again.'
    ]);
}


$conn->close();

?>