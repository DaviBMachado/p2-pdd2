import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/models/task_model.dart';
import 'package:taskflow/theme/app_theme.dart';
import 'package:taskflow/widgets/custom_text_field.dart';
import 'package:taskflow/widgets/empty_state.dart';
import 'package:taskflow/widgets/task_card.dart';
import 'package:taskflow/widgets/task_form.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.retroAnalog,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void main() {
  testWidgets('CustomTextField toggles password visibility', (tester) async {
    await tester.pumpWidget(_wrap(const CustomTextField(label: 'Senha', isPassword: true)));

    expect(tester.widget<EditableText>(find.byType(EditableText)).obscureText, isTrue);
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(tester.widget<EditableText>(find.byType(EditableText)).obscureText, isFalse);
  });

  testWidgets('EmptyState renders content and optional action', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(EmptyState(
      title: 'Sem tarefas',
      subtitle: 'Crie sua primeira tarefa.',
      icon: Icons.inbox_outlined,
      actionLabel: 'Criar',
      onAction: () => tapped = true,
    )));

    expect(find.text('Sem tarefas'), findsOneWidget);
    await tester.tap(find.text('Criar'));
    expect(tapped, isTrue);
  });

  testWidgets('TaskCard displays task info and fires callbacks', (tester) async {
    var toggled = false;
    var tapped = false;
    var deleted = false;
    final task = TaskModel(
      id: 1,
      userId: 1,
      title: 'Ler livro',
      description: 'Capítulo 1',
      priority: 3,
      isCompleted: true,
      category: TaskCategory.study,
      createdAt: DateTime(2026, 11, 18),
      updatedAt: DateTime(2026, 11, 18),
    );

    await tester.pumpWidget(_wrap(TaskCard(
      task: task,
      onToggleStatus: () => toggled = true,
      onTap: () => tapped = true,
      onDelete: () => deleted = true,
    )));

    expect(find.text('ALTA'), findsOneWidget);
    expect(find.text('Faculdade'), findsOneWidget);
    expect(find.text('18/11/2026'), findsOneWidget);
    await tester.tap(find.byTooltip('Marcar como pendente'));
    await tester.tap(find.byTooltip('Excluir tarefa'));
    await tester.tap(find.text('Ler livro'));
    expect(toggled, isTrue);
    expect(deleted, isTrue);
    expect(tapped, isTrue);
  });

  testWidgets('TaskForm validates title, defaults to Média/Pendente/Outro, and pre-fills edit', (tester) async {
    String? submittedTitle;
    int? submittedPriority;
    bool? submittedCompleted;
    TaskCategory? submittedCategory;

    await tester.pumpWidget(_wrap(TaskForm(
      onSubmit: (title, _, priority, isCompleted, category) {
        submittedTitle = title;
        submittedPriority = priority;
        submittedCompleted = isCompleted;
        submittedCategory = category;
      },
    )));

    await tester.tap(find.text('Salvar'));
    await tester.pump();
    expect(find.text('Informe o título da tarefa'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, '  Nova tarefa  ');
    await tester.tap(find.text('Trabalho'));
    await tester.pump();
    await tester.tap(find.text('Salvar'));
    await tester.pump();
    expect(submittedTitle, 'Nova tarefa');
    expect(submittedPriority, 2);
    expect(submittedCompleted, isFalse);
    expect(submittedCategory, TaskCategory.work);

    final existing = TaskModel(
      id: 2,
      userId: 1,
      title: 'Existente',
      description: 'Desc',
      priority: 3,
      isCompleted: true,
      category: TaskCategory.personal,
      createdAt: DateTime(2026, 11, 18),
      updatedAt: DateTime(2026, 11, 18),
    );

    await tester.pumpWidget(_wrap(TaskForm(
      key: const ValueKey('edit'),
      initialTask: existing,
      isLoading: true,
      onSubmit: (_, _, _, _, _) {},
    )));
    expect(find.text('Existente'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
