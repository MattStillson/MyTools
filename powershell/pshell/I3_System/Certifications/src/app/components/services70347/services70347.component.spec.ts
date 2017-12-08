import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { Services70347Component } from './services70347.component';

describe('Services70347Component', () => {
  let component: Services70347Component;
  let fixture: ComponentFixture<Services70347Component>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ Services70347Component ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(Services70347Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
