# Mobile Backend Update Workplan

This workplan turns `MOBILE_BACKEND_UPDATE_HANDOFF.md` into an execution order for the Scenio Flutter app.

Backend goal: Scenio should feel like a guided learning app, not only a practice chat app.

Mobile product loop:

```text
Onboarding -> Learning Plan -> Next Practice -> Session Result -> Next Step
```

---

## 1. Current Mobile Gap Snapshot

Current mobile code already has:

- Auth/session flow
- Home dashboard
- Scenes library and scene detail
- Practice session
- Session result
- Vocabulary tab

Current mobile code does not yet have:

- `learning-plan` endpoints in `ApiEndpoints`
- Learning plan provider/repository methods
- Learning plan models/entities
- Home "Your Learning Plan" block
- Dedicated Learning Plan screen
- Result screen next-step loop
- Semantic search endpoint wiring
- Recommended-scene metadata mapping

---

## 2. Priority Order

### Priority 0 - Contract Foundation

Purpose: make backend contracts available to the app without touching UI first.

Tasks:

- Add endpoints:
  - `GET /learning-plan/current`
  - `POST /learning-plan/generate`
  - `POST /learning-plan/refresh`
  - `PATCH /learning-plan/steps/:id/complete`
  - `GET /scenes/search`
  - `GET /scenes/recommend`
- Add learning plan models:
  - `LearningPlanModel`
  - `LearningPlanStepModel`
  - `LearningPlanResponseModel`
- Add domain entities if needed:
  - `LearningPlanEntity`
  - `LearningPlanStepEntity`
- Extend scene model/entity with optional metadata:
  - `retrievalMode`
  - `focusSkill`
  - `score`
  - `similarity`
  - `matchReason`
- Add repository methods:
  - `fetchCurrentLearningPlan()`
  - `refreshLearningPlan()`
  - `completeLearningPlanStep(stepId)`
  - `searchScenes(query, limit)`
  - `fetchRecommendedScenes(limit)`

Primary files:

- `lib/app/core/network/api_endpoints.dart`
- `lib/app/data/providers/learning_provider.dart`
- `lib/app/domain/repositories/learning_repository.dart`
- `lib/app/data/repositories/learning_repository_impl.dart`
- `lib/app/data/models/`
- `lib/app/domain/entities/`

Done when:

- All DTOs tolerate missing/null backend metadata.
- `retrievalMode` is mapped but not exposed as user-facing UI text.
- `flutter analyze` passes.

---

### Priority 1 - Learning Plan Visible On Home

Purpose: user sees their learning direction as soon as Home loads.

Backend calls on Home:

```http
GET /api/home/dashboard
GET /api/learning-plan/current
```

Tasks:

- Load current learning plan after dashboard load.
- Store loading/error/empty states in `HomeViewModel`.
- Add "Your Learning Plan" card in Home sheet.
- Show:
  - `plan.title`
  - `plan.summary`
  - `plan.focusSkill`
  - `plan.weeklyTarget`
  - progress: completed steps / total steps
- Resolve `nextStep`:
  - first try matching `nextStep.id` against full `steps`
  - fallback to compact `nextStep` object if needed
- CTA behavior:
  - `Start next practice` if next step is a scene and has `sceneId`
  - `Refresh plan` if plan has no usable next step
  - `View plan` opens Learning Plan screen

Primary files:

- `lib/app/modules/home/home_viewmodel.dart`
- `lib/app/modules/home/home_view.dart`
- `lib/app/modules/home/widgets/`
- `lib/app/core/constants/app_strings.dart`
- `lib/app/core/translations/`

Done when:

- Home still renders if learning plan call fails.
- Plan empty state shows refresh action.
- Next scene CTA opens scene detail or starts session using existing scene flow.

---

### Priority 2 - Learning Plan Screen

Purpose: user can inspect the whole roadmap.

Route proposal:

```text
/learning-plan
```

Screen structure:

- Header:
  - `plan.title`
  - `plan.summary`
  - chips for `level`, `learningGoal`, `focusSkill`, `weeklyTarget`
- Timeline/list:
  - `NEXT`: visually prominent with CTA
  - `IN_PROGRESS`: highlighted
  - `LOCKED`: disabled treatment
  - `COMPLETED`: completed tick
  - `SKIPPED`: quiet completed/secondary style
- Step body:
  - `title`
  - `description`
  - `reason`
  - scene metadata when available
- Actions:
  - `Refresh plan`
  - `Mark completed` for manual completion

Primary files:

- `lib/app/modules/learning_plan/learning_plan_binding.dart`
- `lib/app/modules/learning_plan/learning_plan_view.dart`
- `lib/app/modules/learning_plan/learning_plan_viewmodel.dart`
- `lib/app/modules/learning_plan/widgets/`
- `lib/app/routes/app_routes.dart`
- `lib/app/routes/app_pages.dart`

Done when:

- Refresh replaces the current plan without requiring app restart.
- Manual complete updates the timeline from backend response.
- Locked steps are readable but not actionable.

---

### Priority 3 - Session Result To Next Step Loop

Purpose: finishing a session should naturally lead to the next useful practice.

Backend calls after complete:

```http
POST /api/sessions/:id/complete
GET /api/sessions/:id/result
GET /api/learning-plan/current
```

Tasks:

- After result loads, fetch current learning plan.
- Add "Next practice" card to Session Result.
- CTA behavior:
  - `Practice next step`: start/open next scene
  - `Back to plan`: open Learning Plan screen
- Do not call `completeLearningPlanStep` after normal session complete; backend already updates plan.

Primary files:

- `lib/app/modules/chat/chat_viewmodel.dart`
- `lib/app/modules/session_result/session_result_viewmodel.dart`
- `lib/app/modules/session_result/session_result_view.dart`

Done when:

- User can finish a session and continue into the next recommended scene.
- Result screen still works if learning plan fetch fails.

---

### Priority 4 - Semantic Scene Search And Recommendation Metadata

Purpose: use backend pgvector/hybrid recommendation without making the UI technical.

Scene search:

```http
GET /api/scenes/search?q=airport&limit=10
```

Recommended scenes:

```http
GET /api/scenes/recommend?limit=5
```

Tasks:

- Wire search UI to `/scenes/search` instead of local-only filtering.
- Wire recommendations to `/scenes/recommend`.
- Display `matchReason` as a friendly short reason where useful.
- Use `focusSkill` for section title:
  - `GRAMMAR`: "Practice clearer sentences"
  - `VOCABULARY`: "Build useful phrases"
  - `NATURALNESS`: "Sound more natural"
  - `CONFIDENCE`: "Build speaking confidence"
- Treat fallback modes as normal results:
  - `TEXT_FALLBACK`
  - `HEURISTIC_FALLBACK`

Primary files:

- `lib/app/modules/home/widgets/home_scenes_tab.dart`
- `lib/app/modules/home/home_viewmodel.dart`
- scene model/entity files

Done when:

- Search still works when `similarity` is null.
- UI never asks user for Gemini/OpenAI/ElevenLabs keys.
- Raw `retrievalMode` is not shown to normal users.

---

## 3. QA Checklist

Run this after implementing the priorities above:

1. Login learner.
2. Home loads dashboard and current learning plan.
3. Home next-step CTA opens the correct scene.
4. Learning Plan screen renders at least 5 steps.
5. Locked steps cannot be started.
6. Refresh plan updates the plan without crash.
7. Manual complete unlocks the next step.
8. Search `airport` returns results with or without vector mode.
9. Recommended scenes render with fallback modes.
10. Complete a session and confirm Result shows next practice.
11. Back to plan opens the Learning Plan screen.
12. No UI asks user to enter provider/API keys.

---

## 4. Implementation Notes

- Keep learning plan loading independent from dashboard loading so Home is resilient.
- `nextStep` is compact; prefer the matching full step from `steps` when possible.
- Keep enum mapping defensive. Unknown backend enum values should render as neutral labels, not crash.
- Use Scenio design tokens and the existing Home/Scenes visual language.
- Make the first implementation useful and calm. Add polish after the loop works end to end.

